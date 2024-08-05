//
//  UserDefaultsManager.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import Foundation

class UserDefaultsManager: UserStorage {
    private let userDefaults = UserDefaults.standard
    private let userKeyPrefix = "user_"
    
    func saveUsers(_ users: [User]) {
        guard let firstUser = users.first else {
            deleteUsers() // Optionally, clear existing data if no users are provided
            return
        }
        
        _ = userKeyPrefix + "0"
        userDefaults.set(firstUser.id, forKey: userKeyPrefix + "id")
        userDefaults.set(firstUser.name, forKey: userKeyPrefix + "name")
        userDefaults.set(firstUser.username, forKey: userKeyPrefix + "username")
        userDefaults.set(firstUser.email, forKey: userKeyPrefix + "email")
        userDefaults.set(firstUser.phone, forKey: userKeyPrefix + "phone")
    }
    
    func loadUsers() -> [User] {
        guard
            let id = userDefaults.value(forKey: userKeyPrefix + "id") as? Int,
            let name = userDefaults.string(forKey: userKeyPrefix + "name"),
            let username = userDefaults.string(forKey: userKeyPrefix + "username"),
            let email = userDefaults.string(forKey: userKeyPrefix + "email"),
            let phone = userDefaults.string(forKey: userKeyPrefix + "phone")
        else {
            return []
        }
        
        let user = User(id: id, name: name, username: username, email: email, phone: phone)
        return [user]
    }
    
    func deleteUsers() {
        userDefaults.removeObject(forKey: userKeyPrefix + "id")
        userDefaults.removeObject(forKey: userKeyPrefix + "name")
        userDefaults.removeObject(forKey: userKeyPrefix + "username")
        userDefaults.removeObject(forKey: userKeyPrefix + "email")
        userDefaults.removeObject(forKey: userKeyPrefix + "phone")
    }
}



