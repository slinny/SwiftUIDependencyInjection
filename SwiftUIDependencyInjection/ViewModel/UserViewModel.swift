//
//  UserViewModel.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import SwiftUI
import CoreData

class UserViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    private var apiManager: NetworkSession
    private var storageOption: StorageOption
    private var cache = NSCache<NSString, NSArray>()
    
    enum StorageOption {
        case userDefaults
        case coreData
        case nsCache
    }
    
    init(apiManager: NetworkSession = URLSessionManager(),
         storageOption: StorageOption = .userDefaults) {
        self.apiManager = apiManager
        self.storageOption = storageOption
        loadUsers()
    }
    
    func fetchUsers(from urlString: String, completion: @escaping () -> ()) {
        apiManager.fetchData(from: urlString) { data in
            guard let data = data else {
                print("Error: \(URLError.badServerResponse)")
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode([User].self, from: data) else {
                print("Error: \(URLError.cannotDecodeRawData)")
                return
            }
            
            DispatchQueue.main.async {
                self.users = decodedData
                self.saveUsers(self.users)
                completion()
            }
        }
    }
    
    func setApiManager(_ apiManager: NetworkSession) {
        self.apiManager = apiManager
    }
    
    func setStorageOption(_ storageOption: StorageOption) {
        self.storageOption = storageOption
    }
    
    func getUsers() -> [User] {
        self.loadUsers()
        return users
    }
}

extension UserViewModel {
    private func saveUsers(_ users: [User]) {
        switch storageOption {
        case .userDefaults:
            saveToUserDefaults(users)
        case .coreData:
            saveToCoreData(users)
        case .nsCache:
            saveToNSCache(users)
        }
    }
    
    private func saveToUserDefaults(_ users: [User]) {
        let userDefaults = UserDefaults.standard
        if let encodedData = try? JSONEncoder().encode(users) {
            userDefaults.set(encodedData, forKey: "users")
        }
    }
    
    private func saveToCoreData(_ users: [User]) {
        let context = PersistenceController.shared.container.viewContext
        
        // Remove all existing users
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
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
    
    private func saveToNSCache(_ users: [User]) {
        let cacheKey = NSString(string: "users")
        cache.setObject(users as NSArray, forKey: cacheKey)
    }
}

extension UserViewModel {
    private func loadUsers() {
        switch storageOption {
        case .userDefaults:
            loadFromUserDefaults()
        case .coreData:
            loadFromCoreData()
        case .nsCache:
            loadFromNSCache()
        }
    }
    
    private func loadFromUserDefaults() {
        let userDefaults = UserDefaults.standard
        if let savedData = userDefaults.data(forKey: "users"),
           let decodedData = try? JSONDecoder().decode([User].self, from: savedData) {
            self.users = decodedData
        }
    }
    
    private func loadFromCoreData() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            let userEntities = try context.fetch(fetchRequest)
            self.users = userEntities.map { User(id: Int($0.id), name: $0.name, username: $0.username, email: $0.email, phone: $0.phone) }
        } catch {
            print("Failed to fetch users from Core Data: \(error)")
        }
    }
    
    private func loadFromNSCache() {
        let cacheKey = NSString(string: "users")
        if let cachedUsers = cache.object(forKey: cacheKey) as? [User] {
            self.users = cachedUsers
        }
    }
}


