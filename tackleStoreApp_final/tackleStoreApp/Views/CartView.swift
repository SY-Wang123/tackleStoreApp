//  CartView.swift
//  tackleStoreApp
//  Created by Shiyao Wang on 5/5/2024.

import SwiftUI

// SwiftUI view for the shopping cart interface
struct CartView: View {
    @StateObject var vm = CartViewModel()  // State object for the cart ViewModel
    
    // State variables for alert presentation
    @State var showAlert = false
    @State var alertText = ""
    
    // State variable to control the presentation of the checkout view
    @State var showBuyView = false
    
    var body: some View {
        VStack {
            // List displaying the products added to the cart
            List(0..<vm.products.count, id: \.self) { index in
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name:\(vm.products[index].productName)")
                    Text("Stock:\(vm.products[index].productStock)")
                    Text(String(format: "Price:%.2lf", vm.products[index].productPrice))
                    
                    // Interactive quantity adjustment section
                    HStack {
                        Text("-").font(.largeTitle).onTapGesture {
                            // Decrease the quantity of the product
                            print("click -")
                            _ = vm.addOneProduct(productId: vm.products[index].productId, num: -1)
                        }
                        Text("\(String(vm.products[index].quantity ?? 1))")
                            .frame(minWidth: 50)
                            .padding(10)
                        Text("+").font(.largeTitle).onTapGesture {
                            // Increase the quantity of the product
                            print("click +")
                            _ = vm.addOneProduct(productId: vm.products[index].productId, num: 1)
                        }
                    }
                }
            }
            // Total price and checkout button
            HStack {
                Spacer().frame(width: 20)
                Text(String(format: "Total price:%.2lf", vm.products.reduce(0, { $0 + $1.productPrice * Double(($1.quantity ?? 1))})))
                Spacer()
                Button(action: {
                    // Action to perform when checkout is pressed
                    if vm.products.isEmpty {
                        return
                    }
                    // Check if there is enough stock for all products in the cart
                    for product in vm.products {
                        if product.productStock < (product.quantity ?? 1) {
                            alertText = "No enough stock"
                            showAlert = true
                            return
                        }
                    }
                    // Proceed to the buy view if stock is sufficient
                    showBuyView = true
                    
                }, label: {
                    Text("Checkout")
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(.blue)
                        .cornerRadius(10)
                })
                .padding(10)
            }
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertText), dismissButton: .default(Text("OK")))
        })
        .navigationDestination(isPresented: $showBuyView, destination: {
            BuyView()  // Navigate to the BuyView when checkout is initiated
        })
        .navigationTitle("Cart")
    }
}

// Preview provider for SwiftUI Previews
#Preview {
    CartView()
}
