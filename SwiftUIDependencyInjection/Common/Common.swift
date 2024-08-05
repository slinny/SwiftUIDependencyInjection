//
//  Common.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import Foundation

enum Common: String {
    case urlString = "https://jsonplaceholder.typicode.com/users"
}

protocol UserStorage {
    func saveUsers(_ users: [User])
    func loadUsers() -> [User]
    func deleteUsers()
}

protocol NetworkSession {
    func fetchData(from urlString: String, completion: @escaping (Data?) -> Void)
}
