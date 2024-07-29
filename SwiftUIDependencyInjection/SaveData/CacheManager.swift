//
//  CacheManager.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import Foundation

class UserWrapper: NSObject {
    let user: User
    
    init(user: User) {
        self.user = user
    }
}

class CacheManager {
    private let cache = NSCache<NSString, UserWrapper>()
    
    func saveUser(_ user: User, forKey key: String) {
        let userWrapper = UserWrapper(user: user)
        cache.setObject(userWrapper, forKey: key as NSString)
    }
    
    func loadUser(forKey key: String) -> User? {
        return cache.object(forKey: key as NSString)?.user
    }
    
    func removeUser(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAllUsers() {
        cache.removeAllObjects()
    }
}
