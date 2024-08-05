//
//  CacheManager.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import Foundation

class UserWrapper: NSObject {
    let users: [User]
    
    init(users: [User]) {
        self.users = users
    }
}

class CacheManager: UserStorage {
    private let cache = NSCache<NSString, UserWrapper>()
    private let userKey = "userKey"
    
    func saveUsers(_ users: [User]) {
        let userWrapper = UserWrapper(users: users)
        cache.setObject(userWrapper, forKey: userKey as NSString)
    }
    
    func loadUsers() -> [User] {
        return cache.object(forKey: userKey as NSString)?.users ?? []
    }
    
    func deleteUsers() {
        cache.removeObject(forKey: userKey as NSString)
    }
}


