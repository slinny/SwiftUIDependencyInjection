//
//  PersistenceController.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreDataModels") // Replace with your .xcdatamodeld file name
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}

