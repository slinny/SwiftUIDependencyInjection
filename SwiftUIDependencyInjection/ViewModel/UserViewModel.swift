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
    private var storage: UserStorage
    
    init(apiManager: NetworkSession,
         storage: UserStorage) {
        self.apiManager = apiManager
        self.storage = storage
        loadUsers()
    }
    
    func fetchUsers(from urlString: String) {
        apiManager.fetchData(from: urlString) { data in
            guard let data = data else {
                print("Error: \(URLError.badServerResponse)")
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode([User].self, from: data) else {
                print("Error: \(URLError.cannotDecodeRawData)")
                return
            }
            
            self.users = decodedData
            self.storage.saveUsers(self.users)
            self.loadUsers()
        }
    }
    
    func setApiManager(_ apiManager: NetworkSession) {
        self.apiManager = apiManager
    }
    
    func setStorage(_ storage: UserStorage) {
        self.storage = storage
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    private func loadUsers() {
        self.users = storage.loadUsers()
    }
}
