//
//  EntityExtensions.swift
//  tackleStoreApp
//
//  Created by Shiyao Wang on 2024/5/4.
//

import Foundation
import CoreData

extension UserEntity {
    
    func setValues(userModel: UserModel) {
        
        self.userId = Int64(userModel.userId)
        self.userPassword = userModel.userPassword
        self.userName = userModel.userName
        self.userEmail = userModel.userEmail
        self.userPhone = userModel.userPhone
        
        self.isAdmin = userModel.isAdmin
    }
    
    func converToUserModel() -> UserModel {
        return UserModel(userId: userId, userName: userName ?? "", userPhone: userPhone ?? "", userEmail: userEmail ?? "", userPassword: userPassword ?? "" ,isAdmin:isAdmin)
    }
}


extension OrderEntity {
    func setValues(orderModel: OrderModel) {
        self.orderId = Int64(orderModel.orderId)
        self.userId = Int64(orderModel.userId)
        self.orderDate = orderModel.orderDate
        self.orderStatus = orderModel.orderStatus
        self.totalPrice = orderModel.totalPrice
        self.orderAddress = orderModel.orderAddress
        self.orderPhone = orderModel.orderPhone
        self.orderEmail = orderModel.orderEmail
        let context = self.managedObjectContext!
        var list: [OrderItemEntity]?
        
        for (_, orderItem ) in orderModel.orderItem.enumerated() {
            let newOrder = NSEntityDescription.insertNewObject(forEntityName: entity_orderItem, into: context) as! OrderItemEntity
            newOrder.setValues(orderModel: orderItem)
            //newOrder.order = self
            self.addToOrderItem(newOrder)
            list?.append(newOrder)
        }
        
        
    }
    func converToOrderModel() -> OrderModel {
        return  OrderModel(orderId: orderId, userId: userId, orderDate: orderDate ?? Date(), orderStatus: orderStatus, totalPrice: totalPrice, orderAddress: orderAddress ?? "", orderEmail:  orderEmail ?? "", orderPhone: orderPhone ?? "", orderItem: [])
    }
}


extension OrderItemEntity {
    func setValues(orderModel: OrderItemModel) {
        self.orderItemId = Int64(orderModel.orderItemId)
        self.orderId = Int64(orderModel.orderId)
        self.productId = Int64(orderModel.productId)
        self.quantity = Int64(orderModel.quantity)
        self.itemPrice = orderModel.itemPrice
    }
    
    func converToOrderItemModel() -> OrderItemModel {
        return OrderItemModel(orderItemId: orderItemId, orderId: orderId, productId: productId, quantity: quantity, itemPrice: itemPrice)
    }
}


extension ProductEntity {
    
    func setValues(productModel: ProductModel)  {
        self.productId = Int64(productModel.productId)
        self.productName = productModel.productName
        self.productType = productModel.productType
        self.productPrice = productModel.productPrice
        self.productStock = Int64(productModel.productStock)
       // self.orderItem = productModel.orderItem
    }
    
    func converToProductModel() -> ProductModel {
        return ProductModel(productId: productId, productName: productName ?? "", productType: productType ?? "", productPrice: productPrice, productStock: productStock)
    }
}


