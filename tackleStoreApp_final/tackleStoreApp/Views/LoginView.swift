//  LoginView.swift
//  tackleStoreApp
//  Created by Shiyao Wang on 5/5/2024.

import SwiftUI

// Constants for admin account details
let adminAccount: Int64 = 1
let adminPwd = "123"

// SwiftUI view for user login functionality
struct LoginView: View {
    
    // Environment object to access and manipulate user data
    @EnvironmentObject var vm: UserViewModel
    
    // State variables for user input
    @State var account = ""
    @State var pwd = ""
    @State var showRegister = false
    @State var showAlert = false
    @State var alertText = ""
    
    // AppStorage to check if an admin account is initialized
    @AppStorage("ishadAdmin") var ishadAdmin: Bool = false
    
    // Body of the view
    var body: some View {
        NavigationStack {
            VStack(content: {
                // App title
                Text("Super Tackle Delivery App")
                    .font(.largeTitle)
                    .padding(.bottom, 100)
                
                // Username input
                HStack {
                    Text("Username:").padding()
                    TextField("Please enter username", text: $account)
                        .textFieldStyle(.roundedBorder)
                }
                
                // Password input
                HStack {
                    Text("Password").padding()
                    TextField("Please enter password", text: $pwd)
                        .textFieldStyle(.roundedBorder)
                }
                
                // Login button
                Button(action: {
                    loginAction()
                }, label: {
                    Text("Sign in").font(.title)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 130)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                Spacer().frame(height: 20)
                
                // Register button
                Button(action: {
                    showRegister = true
                }, label: {
                    Text("Sign up").font(.title)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 130)
                        .padding(.vertical, 10)
                        .background(Color.gray)
                        .cornerRadius(10)
                })
                
            })
            .padding(.horizontal, 20)
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text(alertText))
            })
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
        }.task {
            // Check and create an admin account on first launch
            if ishadAdmin == false {
                if vm.addOneUser(userModel: UserModel(userId: adminAccount, userName: "", userPhone: "", userEmail: "", userPassword: adminPwd, isAdmin: true)) {
                    ishadAdmin = true
                }
            }
        }
    }
    
    // Function to handle login action
    func loginAction() {
        if account.isEmpty || pwd.isEmpty {
            showAlert = true
            alertText = "Username or password empty"
            return
        }
        
        let success = vm.queryUser(userModel: UserModel(userId: Int64(account) ?? 0, userName: "", userPhone: "", userEmail: "", userPassword: pwd, isAdmin: false))
        if !success {
            showAlert = true
            alertText = "Username or password wrong"
        }
    }
}

// Preview provider for SwiftUI Previews
#Preview {
    LoginView()
}
