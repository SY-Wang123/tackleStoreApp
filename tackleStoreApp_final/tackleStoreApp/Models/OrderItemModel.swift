//
//  OrderItemView.swift
//  tackleStoreApp
//
//  Created by Shiyao Wang on 3/5/2024.
//

import SwiftUI

class OrderItemModel {
    var orderItemId: Int64
    var orderId: Int64
    var productId: Int64
    var quantity: Int64
    var itemPrice: Double
    
    var product: ProductModel?
    init(orderItemId: Int64, orderId: Int64, productId: Int64, quantity: Int64, itemPrice: Double, product: ProductModel? = nil) {
        self.orderItemId = orderItemId
        self.orderId = orderId
        self.productId = productId
        self.quantity = quantity
        self.itemPrice = itemPrice
        self.product = product
    }

//    init(orderItemId: Int64, orderId: Int64, productId: Int64, quantity: Int64, itemPrice: Double) {
//        self.orderItemId = orderItemId
//        self.orderId = orderId
//        self.productId = productId
//        self.quantity = quantity
//        self.itemPrice = itemPrice
//    }
}



