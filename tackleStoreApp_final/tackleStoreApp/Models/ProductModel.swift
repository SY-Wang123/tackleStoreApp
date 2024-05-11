//
//  ProductView.swift
//  tackleStoreApp
//
//  Created by Shiyao Wang on 3/5/2024.
//

import SwiftUI



class ProductModel:Codable {
    var productId: Int64
    var productName: String
    var productType: String
    var productPrice: Double
    var productStock: Int64
    
    var quantity: Int64? = 1
    
    init(productId: Int64, productName: String, productType: String, productPrice: Double, productStock: Int64) {
        self.productId = productId
        self.productName = productName
        self.productType = productType
        self.productPrice = productPrice
        self.productStock = productStock
    }
}


