//
//  CoreDataManager.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import Foundation
import CoreData

class CoreDataManager: UserStorage {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "YourDataModelName") // Replace with your .xcdatamodeld file name
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveUsers(_ users: [User]) {
        let context = persistentContainer.viewContext

        // Remove all existing users
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest() as! NSFetchRequest<NSFetchRequestResult>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to delete existing users: \(error)")
        }

        // Add new users
        for user in users {
            let userEntity = UserEntity(context: context)
            userEntity.id = Int64(user.id ?? 0)
            userEntity.name = user.name
            userEntity.username = user.username
            userEntity.email = user.email
            userEntity.phone = user.phone
        }

        do {
            try context.save()
        } catch {
            print("Failed to save users to Core Data: \(error)")
        }
    }

    func loadUsers() -> [User] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            let userEntities = try context.fetch(fetchRequest)
            return userEntities.map { User(id: Int($0.id), name: $0.name, username: $0.username, email: $0.email, phone: $0.phone) }
        } catch {
            print("Failed to fetch users from Core Data: \(error)")
            return []
        }
    }

    func deleteUsers() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest() as! NSFetchRequest<NSFetchRequestResult>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to delete users from Core Data: \(error)")
        }
    }
}





