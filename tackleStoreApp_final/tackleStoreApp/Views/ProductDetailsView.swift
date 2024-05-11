//  ProductDetailsView.swift
//  tackleStoreApp
//  Created by Shiyao Wang on 7/5/2024.

import SwiftUI
import CoreData

// SwiftUI view displaying detailed information about a product
struct ProductDetailsView: View {
    @EnvironmentObject var vm: ProductViewModel   // Product ViewModel for business logic
    @Environment(\.managedObjectContext) private var viewContext  // Core Data context for saving changes locally
    @ObservedObject var productEntity: ProductEntity  // The product entity this view will display
    @State var productStock = ""  // State for handling input in stock change field
    @State var showAlert = false  // State to control alert presentation
    @State var alertText = ""  // State to hold the alert message

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Display the product details
            Text("Name:\(productEntity.productName!)")
            Text("Type:\(productEntity.productType!)")
            Text(String(format: "Price:%.2lf", productEntity.productPrice))
            Text("Stock:\(productEntity.productStock)")
            
            // Conditional UI based on whether the user is an admin
            if UserViewModel.shared.currentUser!.isAdmin {
                HStack {
                    Text("Change stock:")
                    TextField("Stock", text: $productStock)  // TextField for entering new stock value
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .textFieldStyle(.roundedBorder)
                }.padding(.vertical, 10)
                
                HStack {
                    Spacer()
                    Button(action: {
                        sureStock()
                    }, label: {
                        Text("Confirm Stock")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                            .background(.blue)
                    })
                    .cornerRadius(10)
                    Spacer()
                }
                Spacer()
            } else {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        addToCart()
                    }, label: {
                        Text("Add to cart")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                            .background(.blue)
                    })
                    .cornerRadius(10)
                    Spacer().frame(width: 20)
                }.padding(.vertical, 10)
            }
        }
        .padding(15)
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertText))
        })
        .toolbar(.hidden, for: .tabBar)
        .task {
            productStock = String(productEntity.productStock)  // Initialize the stock text field when the view appears
        }
    }
    
    // Function to add the product to the cart
    func addToCart() {
        if productEntity.productStock <= 0 {
            showAlert = true
            alertText = "No enough stock"
            return
        }
        if CartViewModel().addOneProduct(productId: productEntity.productId) {
            showAlert = true
            alertText = "Add to cart successful"
        } else {
            showAlert = true
            alertText = "Add to cart fail"
        }
    }
    
    // Function to confirm the new stock value entered by the user
    func sureStock() {
        if Int64(productStock) == nil {
            showAlert = true
            alertText = "Please enter correct stock"
            return
        }
        productEntity.productStock = Int64(productStock) ?? 0  // Update the stock in Core Data
        do {
            try viewContext.save()  // Save the context to persist changes
        } catch {
            print(error.localizedDescription)
        }
    }
}

// Uncomment the following to provide a preview in Xcode
/*
#Preview {
    ProductDetailsView(productEntity: ProductEntity(entity: NSEntityDescription(), insertInto: PersistenceController.shared.container.viewContext))
}
*/
