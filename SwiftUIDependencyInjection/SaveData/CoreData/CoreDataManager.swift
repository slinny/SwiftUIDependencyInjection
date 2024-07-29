//
//  CoreDataManager.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import Foundation
import CoreData

class CoreDataManager {
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

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // CRUD Operations for UserEntity
    func createUser(id: Int, name: String, username: String, email: String, phone: String) {
        let userEntity = UserEntity(context: context)
        userEntity.id = Int64(id)
        userEntity.name = name
        userEntity.username = username
        userEntity.email = email
        userEntity.phone = phone

        saveContext()
    }

    func fetchUsers() -> [UserEntity] {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch users: \(error)")
            return []
        }
    }

    func updateUser(user: UserEntity, name: String, username: String, email: String, phone: String) {
        user.name = name
        user.username = username
        user.email = email
        user.phone = phone

        saveContext()
    }

    func deleteUser(user: UserEntity) {
        context.delete(user)
        saveContext()
    }
}



