//
//  UserDefaultsManager.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import Foundation

class UserDefaultsManager {
    private let userDefaults = UserDefaults.standard
    private let userKey = "userKey"
    
    func saveUser(_ user: User) {
        do {
            let data = try JSONEncoder().encode(user)
            userDefaults.set(data, forKey: userKey)
        } catch {
            print("Failed to encode user: \(error.localizedDescription)")
        }
    }
    
    func loadUser() -> User? {
        guard let data = userDefaults.data(forKey: userKey) else { return nil }
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } catch {
            print("Failed to decode user: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteUser() {
        userDefaults.removeObject(forKey: userKey)
    }
}
