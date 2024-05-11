// ContentView.swift
// tackleStoreApp
// Created by Shiyao Wang on 1/5/2024.

import SwiftUI
import CoreData

// Define a SwiftUI view named ContentView.
struct ContentView: View {
    // Environment property to access the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch request to retrieve 'Item' entities, sorted by timestamp.
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>  // Collection of fetched results.

    // Main body of ContentView, describing the view's content.
    var body: some View {
        NavigationView {
            List {
                // Loop over each item fetched from CoreData.
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)  // Enables swipe to delete functionality.
            }
            .toolbar {
                // Toolbar item for an edit button on the navigation bar.
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()  // Default edit button for list editing.
                }
                // Toolbar item for an add button.
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")  // Button to add new items.
                    }
                }
            }
        }
    }

    // Function to add a new item to the CoreData managed object context.
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)  // Create a new Item object.
            newItem.timestamp = Date()  // Set the current date and time as timestamp.

            do {
                try viewContext.save()  // Attempt to save changes to the context.
            } catch {
                // Error handling: print error and crash the app (not recommended for production).
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // Function to delete selected items.
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)  // Delete each selected item.

            do {
                try viewContext.save()  // Attempt to save the context after deletion.
            } catch {
                // Error handling: print error and crash the app (not recommended for production).
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// DateFormatter to format the timestamp displayed for each item.
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// Preview provider for ContentView with a mocked managed object context.
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
