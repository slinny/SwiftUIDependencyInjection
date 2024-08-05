//
//  UserParser.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 8/5/24.
//

import Foundation

class UserParser {
    func parseUsers(from data: Data) -> [User]? {
        do {
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}
