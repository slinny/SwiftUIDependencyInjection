//
//  OptionViewsView.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import SwiftUI

struct OptionView: View {
    @StateObject private var viewModel = UserViewModel(
        apiManager: URLSessionManager(),
        storage: UserDefaultsManager(),
        parser: UserParser() 
    )
    
    var body: some View {
        VStack {
            // Crash Button
            Button(action: {
                // Add your crash testing code here
            }) {
                Text("Test Crash")
                    .font(.title3)
                    .bold()
            }
            .frame(width: 300, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding()
            
            // ScrollView Placeholder
            ScrollView {
                VStack(alignment: .leading) { // Aligns the VStack to the leading edge (left)
                    if viewModel.getUsers().isEmpty {
                        Text("No users found")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        let users = viewModel.getUsers()
                        ForEach(users.compactMap { $0.id != nil ? $0 : nil }, id: \.id) { user in
                            Text("Username: \(user.username ?? "")")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading) // Aligns the text to the left
                        }
                    }
                }
            }
            .task {
                viewModel.fetchUsers(from: Common.urlString.rawValue)
            }
        }
    }
}

#Preview {
    OptionView()
}
