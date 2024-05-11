//  RegisterView.swift
//  tackleStoreApp
//  Created by Shiyao Wang on 5/5/2024.

import SwiftUI

// SwiftUI view for user registration functionality
struct RegisterView: View {
    @Environment(\.dismiss) var dismiss  // Environment value to dismiss the view
    @EnvironmentObject var vm: UserViewModel  // Environment object to access and manipulate user data
    
    // State variables for user input
    @State var account = ""
    @State var pwd = ""
    
    // State variables for alert handling
    @State var showAlert = false
    @State var alertText = ""
    @State var needDismiss = false  // Controls whether the view should dismiss after an action
    
    var body: some View {
        VStack(content: {
            // Username input
            HStack {
                Text("Username:").padding()
                TextField("Please enter username", text: $account)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Password input
            HStack {
                Text("password").padding()
                TextField("Please enter password", text: $pwd)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Sign up button with action
            Button(action: {
                registerAction()
            }, label: {
                Text("Sign up").font(.title)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 130)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            
        })
        .padding(.horizontal, 20)
        .alert(isPresented: $showAlert, content: {
            // Alert configuration with a condition to dismiss the view on successful registration
            Alert(title: Text(alertText), dismissButton: .default(Text("OK"), action: {
                if needDismiss {
                    dismiss()
                }
            }))
        })
        
    }
    
    // Function to handle registration logic
    func registerAction() {
        // Check if username or password fields are empty
        if account.isEmpty || pwd.isEmpty {
            showAlert = true
            alertText = "Username or password empty"
            return
        }
        
        // Mock check for existing user (should be replaced with actual validation logic)
        if account == "1" {
            showAlert = true
            alertText = "Username exist"
            return
        }
        
        // Attempt to add a new user using the user view model
        let success = vm.addOneUser(userModel: UserModel(userId: Int64(account) ?? 0, userName: "", userPhone: "", userEmail: "", userPassword: pwd, isAdmin: false))
        showAlert = true
        if success {
            alertText = "Sign up successful"
            needDismiss = true  // Set to dismiss the view after successful registration
        } else {
            alertText = "Sign up fail"
        }
    }
}

// Preview provider for SwiftUI Previews
#Preview {
    RegisterView()
}
