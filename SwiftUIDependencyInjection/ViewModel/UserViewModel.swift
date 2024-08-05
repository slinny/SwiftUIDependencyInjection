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
    private let parser: UserParser // Add a parser property
    
    init(apiManager: NetworkSession,
         storage: UserStorage,
         parser: UserParser) { // Inject parser in initializer
        self.apiManager = apiManager
        self.storage = storage
        self.parser = parser
        loadUsers()
    }
    
    func fetchUsers(from urlString: String) {
        apiManager.fetchData(from: urlString) { data in
            guard let data = data else {
                print("Error: \(URLError.badServerResponse)")
                return
            }
            
            if let decodedData = self.parser.parseUsers(from: data) {
                DispatchQueue.main.async {
                    self.users = decodedData
                    self.storage.saveUsers(self.users)
                    self.loadUsers()
                }
            } else {
                print("Error: Failed to parse user data")
            }
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

