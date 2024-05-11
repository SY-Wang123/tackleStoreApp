//  ProductListView.swift
//  tackleStoreApp
//  Created by Shiyao Wang on 8/5/2024.

import SwiftUI

// SwiftUI view that displays a list of products fetched from Core Data
struct ProductListView: View {
  
    // Environment variable to access the managed object context from the SwiftUI view
    @Environment(\.managedObjectContext) private var viewContext

    // FetchRequest to automatically fetch ProductEntity data from Core Data, sorted by productId
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ProductEntity.productId, ascending: true)],
        animation: .default)
    private var productEntitys: FetchedResults<ProductEntity>  // Collection of fetched product entities

    var body: some View {
        // List of products using indices to iterate through product entities
        List(0..<productEntitys.count, id: \.self) { index in
            // Navigation link to product details view
            NavigationLink {
                ProductDetailsView(productEntity: productEntitys[index])
            } label: {
                // Product information displayed in a vertical stack
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name:\(productEntitys[index].productName!)")  // Display the product name
                    Text("Type:\(productEntitys[index].productType!)")  // Display the product type
                    Text(String(format: "Price:%.2lf", productEntitys[index].productPrice))  // Display the price formatted to two decimal places
                    Text("Stock:\(productEntitys[index].productStock)")  // Display the available stock
                }
            }
        }
        .onAppear(perform: {
            // Debug print to check the count of fetched product entities
            print("productEntitys:\(productEntitys.count)")
        })
        .navigationTitle("Product list")  // Navigation bar title
    }
}

// Preview provider for SwiftUI Previews
#Preview {
    ProductListView()
}
