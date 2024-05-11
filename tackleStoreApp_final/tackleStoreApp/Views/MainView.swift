//  MainView.swift
//  tackleStoreApp
//  Created by Shiyao Wang on 7/5/2024.

import SwiftUI

// Main interface for the app, managing navigation between different views using a tab bar
struct MainView: View {
    @EnvironmentObject var userVM: UserViewModel  // Environment object to access user data across the app

    // State variable to manage the selected tab index
    @State var selTabIndex = 0

    var body: some View {
        // TabView to handle different sections of the app
        if userVM.currentUser == nil {
            EmptyView()
        } else {
            TabView(selection: $selTabIndex, content: {
                // Navigation stack for the main product list view
                NavigationStack {
                    ProductListView()
                }
                .tabItem {
                    // Tab item for the home page
                    Image(systemName: "house.circle.fill")
                    Text("Main")
                }
                .tag(0)
                
                // Conditionally display the Cart tab only for non-admin users
                if userVM.currentUser!.isAdmin == false {
                    NavigationStack {
                        CartView()
                    }
                    .tabItem {
                        // Tab item for the shopping cart
                        Image(systemName: "cart.fill")
                        Text("Cart")
                    }
                    .tag(1)
                }

                // Navigation stack for the order list view
                NavigationStack {
                    OrderListView()
                }
                .tabItem {
                    // Tab item for orders
                    Image(systemName: "list.bullet.circle.fill")
                    Text("Order")
                }
                .tag(2)

                // Navigation stack for the user profile view
                NavigationStack {
                    UserView()
                }
                .tabItem {
                    // Tab item for the user profile section
                    Image(systemName: "person.crop.circle.fill")
                    Text("Me")
                }
                .tag(3)
            })
        }
       
    }
}

// Preview provider for SwiftUI Previews
#Preview {
    MainView()
}
