//
//  tackleStoreAppApp.swift
//  tackleStoreApp
//
//  Created by Shiyao Wang on 30/4/2024.
//

import SwiftUI

@main
struct tackleStoreAppApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var userVM = UserViewModel.shared
    var body: some Scene {
        WindowGroup {
            if userVM.currentUser == nil {
                LoginView()
                    .environmentObject(UserViewModel.shared)
                    .onAppear(perform: {
                        print(NSHomeDirectory())
                    })
            } else {
                MainView()
                     .environment(\.managedObjectContext, persistenceController.container.viewContext)
                     .environmentObject(UserViewModel.shared)
                     .environmentObject(ProductViewModel.shared)
                     .onAppear(perform: {
                         print(NSHomeDirectory())
                     })
            }
//            RootView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .environmentObject(UserViewModel.shared)
//                .environmentObject(ProductViewModel.shared)
//               
//                .onAppear(perform: {
//                    print(NSHomeDirectory())
//                })
            
           
        }
    }
}
