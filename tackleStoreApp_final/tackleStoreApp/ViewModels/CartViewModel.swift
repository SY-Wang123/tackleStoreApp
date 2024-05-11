//  CartViewModel.swift
//  tackleStoreApp
//  Created by Shiyao Wang on 2024/5/4.

import Foundation
import CoreData
import SwiftUI

// ViewModel for managing the shopping cart in a SwiftUI app
class CartViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    // Managed object context from the shared persistent controller
    let viewContext = PersistenceController.shared.container.viewContext
    
    // Fetched results controller to manage fetching cart data
    private var requestResultController: NSFetchedResultsController<CartEntity>
    
    // Published array of products currently in the cart
    @Published var products = [ProductModel]()
    
    // Initialization setup for the fetched results controller
    override init() {
        // Fetch request for cart items for the current user
        let fetchRequest = NSFetchRequest<CartEntity>(entityName: entity_cart)
        let predicate = NSPredicate(format: "userId = %ld", UserViewModel.shared.currentUser!.userId)
        fetchRequest.predicate = predicate
        let sortDescriptors: [NSSortDescriptor] = [.init(key: "productId", ascending: false)]
        fetchRequest.sortDescriptors = sortDescriptors
        
        let requestResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        self.requestResultController = requestResultController
        super.init()
        requestResultController.delegate = self
        try? requestResultController.performFetch()
        updateData()
    }
    
    // Delegate method to respond to content changes in the fetched results controller
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Intended for further implementation to handle dynamic updates
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        updateData()  // Update the data whenever changes in the fetched results occur
    }
    
    // Accessor for fetched results
    var fetchResults: [CartEntity] {
        return requestResultController.fetchedObjects ?? []
    }
    
    // Updates the local products array based on fetch results
    func updateData() {
        print("Cart update success")
        let fetchResults = self.fetchResults
        let productIds = fetchResults.map({String($0.productId)}).joined(separator: ",")
        let products = ProductViewModel.shared.queryAllProducts(productIds: productIds)
    
        for (index, product) in products.enumerated() {
            for fetchResult in fetchResults where product.productId == fetchResult.productId {
                products[index].quantity = fetchResult.productQuantity
                break
            }
        }
        self.products = products
    }
    
    // Adds a product to the cart or updates the quantity if already present
    func addOneProduct(productId: Int64, num: Int64 = 1) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_cart)
        let predicate = NSPredicate(format: "userId = %ld && productId = %ld", UserViewModel.shared.currentUser!.userId, productId)
        fetchRequest.predicate = predicate
        do {
            let fetchResults = try self.viewContext.fetch(fetchRequest) as? [CartEntity]
            if let fetchResults = fetchResults, let fetchResult = fetchResults.first {
                let currentNum = fetchResult.productQuantity
                if currentNum + num <= 0 {
                    // Remove product record if quantity falls to zero or below
                    viewContext.delete(fetchResults[0])
                } else {
                    // Update the product quantity
                    fetchResult.productQuantity = currentNum + num
                }
            } else {
                // Create a new cart entity if not already present
                let newCart = NSEntityDescription.insertNewObject(forEntityName: entity_cart, into: viewContext) as! CartEntity
                newCart.productId = productId
                newCart.productQuantity = num
                newCart.userId = UserViewModel.shared.currentUser!.userId
            }
            
            do {
                try viewContext.save()
                print("Add to cart success")
                return true
            } catch {
                print("Add to cart failure: \(error.localizedDescription)")
            }
        } catch {
            print("Adding to cart error: \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    // Clears all products from the user's cart
    func clearCart() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_cart)
        let predicate = NSPredicate(format: "userId = %ld", UserViewModel.shared.currentUser!.userId)
        fetchRequest.predicate = predicate
        
        do {
            if let fetchResults = try self.viewContext.fetch(fetchRequest) as? [CartEntity] {
                fetchResults.forEach(viewContext.delete)
                try viewContext.save()
                print("Cart cleared successfully")
                return true
            }
            print("Error clearing cart")
        } catch {
            print("Error clearing cart: \(error.localizedDescription)")
        }
        return false
    }
}
