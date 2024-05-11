//  UserView.swift
//  tackleStoreApp
//  Created by Shiyao Wang on 5/5/2024.

import SwiftUI

// SwiftUI view representing the user settings or profile screen
struct UserView: View {
    
    // Environment object to access the user view model for authentication operations
    @EnvironmentObject var vm: UserViewModel
    
    var body: some View {
        List {
            // Button to log out the user
            Button(action: {
                // Calls the removeLogin method to clear user session data
                vm.removeLogin()
            }, label: {
                Text("Exit")  // Text displayed on the button
            })
        }
        .navigationTitle("Me")  // Sets the title of the navigation bar
    }
}

// Preview provider for SwiftUI Previews
#Preview {
    UserView()
}
