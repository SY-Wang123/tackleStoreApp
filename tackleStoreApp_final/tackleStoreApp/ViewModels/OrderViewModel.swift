//  OrderViewModel.swift
//  tackleStoreApp
//  Created by Shiyao Wang on 4/5/2024.

import Foundation
import CoreData
import SwiftUI

// Enum representing the possible states of an order
enum OrderState: Int {
    case inProgress = 0
    case canGet = 1
    case finished = 2
    
    // Provides a human-readable name for the order state
    var name : String {
        switch self {
        case .inProgress:
            return "Processing"
        case .canGet:
            return "Ready"
        case .finished:
            return "Finish"
        }
    }
    
    // Provides a name for the operation associated with each state
    var operationName : String {
        switch self {
        case .inProgress:
            return "Confirm processing"
        case .canGet:
            return "Confirm pickup"
        case .finished:
            return ""
        }
    }
}

// ViewModel for managing order data in a SwiftUI app
class OrderViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate  {
    let viewContext = PersistenceController.shared.container.viewContext
    private var requestResultController: NSFetchedResultsController<OrderEntity>
    @Published var orders = [OrderModel]()
    
    override init() {
        // Fetch request setup for orders
        let fetchRequest = NSFetchRequest<OrderEntity>(entityName: entity_order)
        // Limit orders to those of the current user unless they are an admin
        if !UserViewModel.shared.currentUser!.isAdmin {
            let predicate = NSPredicate(format: "userId = %ld", UserViewModel.shared.currentUser!.userId)
            fetchRequest.predicate = predicate
        }
        
        // Sort orders by date, descending
        let sortDescriptors: [NSSortDescriptor] = [.init(key: "orderDate", ascending: false)]
        fetchRequest.sortDescriptors = sortDescriptors
        // Setting up NSFetchedResultsController
        let requestResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        self.requestResultController = requestResultController
        super.init()
        requestResultController.delegate = self
        try? requestResultController.performFetch()
        updateData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Trigger view updates before content changes
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // Update the view model's data when changes in the data source occur
        updateData()
    }
    
    var fetchResults: [OrderEntity] {
        // Get fetched objects from the result controller
        return requestResultController.fetchedObjects ?? []
    }
    
    func updateData() {
        // Refresh the published orders array
        let fetchResults = self.fetchResults
        var orderList = [OrderModel]()
        for (_, fetchResult) in fetchResults.enumerated() {
            let orderModel = fetchResult.converToOrderModel()
            orderList.append(orderModel)
            let orderItemList = queryOrderItem(orderId: fetchResult.orderId)
            orderItemList.forEach { orderItemModel in
                let products = ProductViewModel.shared.queryAllProducts(productIds: String(orderItemModel.productId))
                if let first = products.first {
                    orderItemModel.product = first
                }
            }
            orderModel.orderItem = orderItemList
        }
        self.orders = orderList
    }
    
    // Adds an order to the database and decrements stock as necessary
    func addOrder(orderModel: OrderModel) -> Bool {
        if orderModel.orderItem.isEmpty {
            return false
        }
        let newOrder = NSEntityDescription.insertNewObject(forEntityName: entity_order, into: viewContext) as! OrderEntity
        newOrder.setValues(orderModel: orderModel)
        do {
            try viewContext.save()
            print("register success")
            return true
        } catch {
            print("cannot register")
            return false
        }
    }
    
    // Queries order items for a specific order ID
    func queryOrderItem(orderId: Int64) -> [OrderItemModel] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_orderItem)
        let predicate = NSPredicate(format: "orderId = %ld", orderId)
        fetchRequest.predicate = predicate
        
        do {
            if let fetchResults = try self.viewContext.fetch(fetchRequest) as? [OrderItemEntity] {
                print("queryOrderItem success")
                return fetchResults.map({$0.converToOrderItemModel()})
            }
            print("queryOrderItem error")
            return []
        } catch {
            print("queryOrderItem error")
            return []
        }
    }
    
    // Deletes an order from the database
    func deleteOrder(orderModel: OrderModel) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_order)
        let predicate = NSPredicate(format: "orderId = %ld", orderModel.orderId)
        fetchRequest.predicate = predicate
        
        do {
            if let fetchResults = try self.viewContext.fetch(fetchRequest) as? [OrderEntity], let fetchResult = fetchResults.first {
                viewContext.delete(fetchResult)
                try viewContext.save()
                print("deleteOrder success")
                return true
            }
            print("deleteOrder error")
        } catch {
            print("deleteOrder error")
        }
        
        return false
    }
    
    // Updates the status of an existing order
    func updateOrderState(orderId: Int64, orderStatus: Int64) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_order)
        let predicate = NSPredicate(format: "orderId = %ld", orderId)
        fetchRequest.predicate = predicate
        do {
            let fetchResults = try self.viewContext.fetch(fetchRequest) as? [OrderEntity]
            if let fetchResults = fetchResults, let fetchResult = fetchResults.first {
                fetchResult.orderStatus = orderStatus
                print("updateProductInfo success")
                try viewContext.save()
            }
            print("updateProductInfo error")
        } catch {
            print("updateProductInfo error")
        }
    }
}
