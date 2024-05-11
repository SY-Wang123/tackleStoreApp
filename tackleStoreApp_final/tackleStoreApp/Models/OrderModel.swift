//
//  OrderView.swift
//  tackleStoreApp
//
//  Created by Shiyao Wang on 3/5/2024.
//

import SwiftUI

class OrderModel {
    var orderId: Int64
    var userId: Int64
    var orderDate: Date
    var orderStatus: Int64
    var totalPrice: Double
    var orderAddress : String
    var orderEmail : String
    var orderPhone : String
    var orderItem: [OrderItemModel]
    
    init(orderId: Int64, userId: Int64, orderDate: Date, orderStatus: Int64, totalPrice: Double, orderAddress: String, orderEmail: String, orderPhone: String, orderItem: [OrderItemModel]) {
        self.orderId = orderId
        self.userId = userId
        self.orderDate = orderDate
        self.orderStatus = orderStatus
        self.totalPrice = totalPrice
        self.orderAddress = orderAddress
        self.orderEmail = orderEmail
        self.orderPhone = orderPhone
        self.orderItem = orderItem
    }
    
    


}

