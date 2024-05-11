//
//  UserView.swift
//  tackleStoreApp
//
//  Created by Shiyao Wang on 3/5/2024.
//

import SwiftUI

class UserModel {
    var userId: Int64
    var userName: String
    var userPhone: String
    var userEmail: String
    var userPassword: String
    var isAdmin: Bool
    
    init(userId: Int64, userName: String, userPhone: String, userEmail: String, userPassword: String, isAdmin: Bool) {
        self.userId = userId
        self.userName = userName
        self.userPhone = userPhone
        self.userEmail = userEmail
        self.userPassword = userPassword
        self.isAdmin = isAdmin
    }
}

