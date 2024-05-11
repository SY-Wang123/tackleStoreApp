//  BuyView.swift
//  tackleStoreApp
//  Created by Shiyao Wang on 5/5/2024.

import SwiftUI

// SwiftUI view for handling the checkout process of a shopping cart
struct BuyView: View {
    @StateObject var vm = CartViewModel()  // State object for the cart ViewModel
    @Environment(\.dismiss) var dismiss  // Environment value to dismiss the view

    // State variables to handle user input for the checkout form
    @State var orderPhone = ""
    @State var orderEmail = ""
    @State var orderAddress = ""

    // State variables for alert presentation
    @State var showAlert = false
    @State var alertText = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    // List all products in the cart
                    ForEach(0..<vm.products.count, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Name:\(vm.products[index].productName)")
                            Text("Stock:\(vm.products[index].productStock)")
                            Text(String(format: "Price:%.2lf", vm.products[index].productPrice))
                            Text("x\(String(vm.products[index].quantity ?? 1))")
                            Divider()
                        }
                    }
                    // User input fields for checkout details
                    HStack {
                        Text("Phone:")
                            .padding(.horizontal, 10)
                        TextField("Please enter your phone", text: $orderPhone)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("Email:")
                            .padding(.horizontal, 10)
                        TextField("Please enter your email", text: $orderEmail)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("Address:")
                            .padding(.horizontal, 10)
                        TextField("Please enter your address", text: $orderAddress)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                .padding(10)
                .background(.white)
                .padding(10)
            }
            .background(Color("F3F4F6"))  // Background color for the ScrollView
            Spacer()
            // Display total price and checkout button
            HStack {
                Spacer().frame(width: 20)
                Text(String(format: "Total price:%.2lf", vm.products.reduce(0, { $0 + $1.productPrice * Double(($1.quantity ?? 1))})))
                Spacer()
                Button(action: {
                    buyAction()  // Action to perform the buy operation
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
            Alert(title: Text(alertText), dismissButton: .default(Text("Confirm"), action: {
                if alertText == "Checkout successful" {
                    dismiss()  // Dismiss the view on successful checkout
                }
            }))
        })
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitle(Text("Checkout"))
    }
    
    // Function to execute the checkout process
    func buyAction() {
        // Clean up input strings
        let orderAddress = orderAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let orderEmail = orderEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        let orderPhone = orderPhone.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validate input fields
        if orderAddress.isEmpty {
            showAlert = true
            alertText = "Please enter an address"
            return
        }
        if orderEmail.isEmpty || !orderEmail.isValidEmail() {
            showAlert = true
            alertText = "Please enter a valid email address"
            return
        }
        if orderPhone.isEmpty {
            showAlert = true
            alertText = "Please enter a phone number"
            return
        }
        
        // Construct the order
        let timeInterval = Int(Date().timeIntervalSince1970)
        let orderId = Int64(timeInterval * 1000000 + Int.random(in: 0..<1000000))
        let userId = UserViewModel.shared.currentUser!.userId
        var orderItemList = [OrderItemModel]()
        var totalPrice = 0.0
        
        for product in vm.products {
            let orderItemId = Int64(timeInterval * 1000 + Int.random(in: 0..<1000))
            let orderItemModel = OrderItemModel(orderItemId: orderItemId, orderId: orderId, productId: product.productId, quantity: product.quantity ?? 1, itemPrice: product.productPrice)
            totalPrice += product.productPrice * Double(product.quantity ?? 1)
            orderItemList.append(orderItemModel)
        }
        
        let orderModel = OrderModel(orderId: orderId, userId: userId, orderDate: Date(), orderStatus: 0, totalPrice: totalPrice, orderAddress: orderAddress, orderEmail: orderEmail, orderPhone: orderPhone, orderItem: orderItemList)
        
        // Attempt to add the order
        let result = OrderViewModel().addOrder(orderModel: orderModel)
        if result {
            // Reduce stock and clear the cart if successful
            for product in vm.products {
                product.productStock = product.productStock - (product.quantity ?? 0)
            }
            _ = ProductViewModel.shared.updateProductStock(products: vm.products)
            _ = CartViewModel().clearCart()
            showAlert = true
            alertText = "Checkout successful"
        }
    }
}

// Preview provider for SwiftUI Previews
#Preview {
    BuyView()
}
