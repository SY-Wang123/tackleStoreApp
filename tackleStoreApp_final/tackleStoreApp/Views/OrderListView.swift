//  OrderListView.swift
//  tackleStoreApp
//  Created by Shiyao Wang on 5/5/2024.

import SwiftUI

// SwiftUI view for displaying a list of orders
struct OrderListView: View {
    @StateObject var vm = OrderViewModel()  // State object for the order ViewModel
    
    // State variables for alert presentation and handling order actions
    @State var showAlert = false
    @State var alertText = ""
    @State var currentOrder: OrderModel?  // Current order being acted upon

    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            List(0..<vm.orders.count, id: \.self) { index in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("order id:" + String(vm.orders[index].orderId))
                            .foregroundStyle(.blue)
                        Spacer()
                        Text((OrderState(rawValue: Int(vm.orders[index].orderStatus)) ?? .inProgress).name)
                            .foregroundStyle(.green)
                    }
                    
                    Text("Time:\(vm.orders[index].orderDate, formatter: itemFormatter)")
                    Text(String(format: "Price:%.2lf", vm.orders[index].totalPrice))
                    Text("Address:" + String(vm.orders[index].orderAddress))
                    Text("Phone:" + String(vm.orders[index].orderPhone))
                    Text("Email:" + String(vm.orders[index].orderEmail))

                    // Loop through items in each order
                    ForEach(0..<vm.orders[index].orderItem.count, id: \.self) { itemIndex in
                        Divider()
                        HStack {
                            Spacer().frame(width: 20)
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Price:" + String(vm.orders[index].orderItem[itemIndex].itemPrice))
                                Text("Quantity" + String(vm.orders[index].orderItem[itemIndex].quantity))
                                Text("Name" + String(vm.orders[index].orderItem[itemIndex].product!.productName))
                            }
                        }
                    }
                    Spacer().frame(height: 10)
                    buildOperationView(order: vm.orders[index])
                    Spacer().frame(height: 20)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertText), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Confirm"), action: {
                changeOrderState(order: currentOrder!)
            }))
        })
        .navigationTitle("Order list")
    }
    
    // Function to build view for operation based on order state
    @ViewBuilder
    func buildOperationView(order: OrderModel) -> some View {
        let orderState = OrderState(rawValue: Int(order.orderStatus)) ?? .inProgress
        let isAdmin = UserViewModel.shared.currentUser?.isAdmin ?? false
        
        // Display operation button only for applicable orders based on user role and order state
        if (isAdmin && orderState == .inProgress || !isAdmin && orderState == .canGet) {
            HStack {
                Spacer()
                Button {
                    showAlert = true
                    alertText = "\(orderState.operationName)?"
                    currentOrder = order
                } label: {
                    Text(orderState.operationName)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 10)
                        .background(.blue)
                        .cornerRadius(8)
                }
                Spacer()
            }
        } else {
            EmptyView()
        }
    }
    
    // Function to update the order state
    func changeOrderState(order: OrderModel) {
        vm.updateOrderState(orderId: order.orderId, orderStatus: order.orderStatus + 1)
    }
}

// Preview provider for SwiftUI Previews
#Preview {
    OrderListView()
}

// DateFormatter for displaying the order time
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
