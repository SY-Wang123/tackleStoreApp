//  UserViewModel.swift
//  tackleStoreApp
//  Created by apple on 4/5/2024.

import Foundation
import CoreData
import SwiftUI

// ViewModel managing user data and authentication states
class UserViewModel: ObservableObject {
    
    // Singleton instance for global access
    static var shared = UserViewModel()
    
    // Managed object context from the shared persistent controller
    let viewContext = PersistenceController.shared.container.viewContext
    
    // Currently logged-in user
    @Published var currentUser: UserModel?
    
    // User ID and password stored in AppStorage for persistence across launches
    @AppStorage("userID") var userID: Int = 0
    @AppStorage("userPwd") var userPwd = ""
    
    // Private initializer to possibly fetch the current user at app launch
    private init() {
        // If a user ID is stored, attempt to log in
        if userID > 0 {
            let user = UserModel(userId: Int64(userID), userName: "", userPhone: "", userEmail: "", userPassword: userPwd, isAdmin: userID == adminAccount)
            _ = self.queryUser(userModel: user)
        }
    }
    
    // Method to add a new user to the database
    func addOneUser(userModel: UserModel) -> Bool {
        // Check if the account can be used (not already in use)
        if !canUseAccount(userId: userModel.userId) {
            return false
        }
        // Create a new UserEntity and set its properties
        let newUser = NSEntityDescription.insertNewObject(forEntityName: entity_user, into: viewContext) as! UserEntity
        newUser.setValues(userModel: userModel)
        do {
            try viewContext.save()
            print("register success")
            return true
        } catch {
            print("cannot register")
            return false
        }
    }
    
    // Method to authenticate a user
    func queryUser(userModel: UserModel) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_user)
        let predicate = NSPredicate(format: "userId = %ld && userPassword = %@", userModel.userId, userModel.userPassword)
        fetchRequest.predicate = predicate
        do {
            let fetchResults = try self.viewContext.fetch(fetchRequest) as? [UserEntity]
            if let fetchResults = fetchResults, let fetchResult = fetchResults.first {
                print("login success")
                // Set the current user on successful login
                currentUser = fetchResult.converToUserModel()
                userID = Int(currentUser!.userId)
                userPwd = currentUser!.userPassword
                return true
            }
            print("login error")
            return false
        } catch {
            print("login error")
            return false
        }
    }
    
    // Helper method to check if a user ID is already in use
    private func canUseAccount(userId: Int64) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_user)
        let predicate = NSPredicate(format: "userId = %ld", userId)
        fetchRequest.predicate = predicate
        do {
            let fetchResults = try self.viewContext.fetch(fetchRequest) as? [UserEntity]
            return !(fetchResults != nil && fetchResults!.count > 0)
        } catch {
            return false
        }
    }
    
    // Method to clear the current user session
    func removeLogin() {
        currentUser = nil
        userID = 0
        userPwd = ""
    }
}
