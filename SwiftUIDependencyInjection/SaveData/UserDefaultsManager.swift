//
//  UserDefaultsManager.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import Foundation

class UserDefaultsManager: UserStorage {
    private let userDefaults = UserDefaults.standard
    private let userKey = "userKey"
    
    func saveUsers(_ users: [User]) {
        do {
            let data = try JSONEncoder().encode(users)
            userDefaults.set(data, forKey: userKey)
        } catch {
            print("Failed to encode users: \(error.localizedDescription)")
        }
    }
    
    func loadUsers() -> [User] {
        guard let data = userDefaults.data(forKey: userKey) else { return [] }
        do {
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
        } catch {
            print("Failed to decode users: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteUsers() {
        userDefaults.removeObject(forKey: userKey)
    }
}


