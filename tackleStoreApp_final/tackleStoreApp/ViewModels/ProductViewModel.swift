//  ProductViewModel.swift
//  tackleStoreApp
//  Created by Shiyao Wang on 3/5/2024.

import Foundation
import CoreData
import SwiftUI

// ViewModel for managing product data in a SwiftUI app
class ProductViewModel: ObservableObject {
    // Managed object context from the shared persistent controller
    let viewContext = PersistenceController.shared.container.viewContext
    // Singleton instance for global access
    static var shared = ProductViewModel()
    
    // Property to track if products have been loaded into the database
    @AppStorage("isHadProduct") var isHadProduct = false
    
    // Private initializer to populate the database on first launch
    private init() {
        if isHadProduct == false {
            do {
                // Load product data from bundled JSON file
                let data = try Data(contentsOf: Bundle.main.url(forResource: "product.txt", withExtension: nil)!)
                // Decode JSON data to product models
                let products = try JSONDecoder().decode([ProductModel].self, from: data)
                // Add products to the database
                self.addProducts(productModels: products)
                // Set flag to avoid re-initialization
                isHadProduct = true
            } catch {
                // Handle loading or decoding error
                print(error.localizedDescription)
            }
        } else {
            // Ensure flag is correctly set if initialization was previously done
            isHadProduct = true
        }
    }
    
    // Method to add products to the database
    @discardableResult
    func addProducts(productModels:[ProductModel]) -> Bool {
        for (_, productModel) in productModels.enumerated() {
            let product = NSEntityDescription.insertNewObject(forEntityName: entity_product, into: viewContext) as! ProductEntity
            // Set values from model to new CoreData entity
            product.setValues(productModel: productModel)
        }
        do {
            // Save context to persist data
            try viewContext.save()
            print("register success")
            return true
        } catch {
            // Handle save error
            print("cannot register ")
            return false
        }
    }
    
    // Method to query all products, optionally filtered by product IDs
    func queryAllProducts(productIds: String? = nil) -> [ProductModel] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_product)
        if let productIds = productIds {
            let predicate = NSPredicate(format: "productId IN %@", productIds.components(separatedBy: ","))
            fetchRequest.predicate = predicate
        }
        
        var productList = [ProductModel]()
        do {
            let fetchResults = try self.viewContext.fetch(fetchRequest) as? [ProductEntity]
            if let fetchResults = fetchResults {
                print("queryAllProducts success")
                productList = fetchResults.map({$0.converToProductModel()})
            }
        } catch {
            print("queryAllProducts error")
        }
        return productList
    }
    
    // Method to update product stock
    func updateProductStock(products: [ProductModel]) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_product)
        let predicate = NSPredicate(format: "productId IN %@", products.map({String($0.productId)}))
        fetchRequest.predicate = predicate
        do {
            let fetchResults = try self.viewContext.fetch(fetchRequest) as? [ProductEntity]
            if let fetchResults = fetchResults {
                for fetchResult in fetchResults {
                    for product in products where fetchResult.productId == product.productId {
                        fetchResult.productStock = product.productStock
                        break
                    }
                }
                try viewContext.save()
                print("updateProductInfo success")
                return true
            }
            print("updateProductInfo error")
        } catch {
            print("updateProductInfo error")
        }
        return false
    }
}
