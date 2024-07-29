//
//  UserModel.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import Foundation

// MARK: - User Model
struct User: Codable, Identifiable, Hashable {
    let id: Int?
    let name: String?
    let username: String?
    let email: String?
    let phone: String?
}
