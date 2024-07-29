//
//  OptionViewsView.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import SwiftUI

struct OptionView: View {
    @State private var fetchingMethods: String = "Alamofire"
    @State private var savingMethods: String = "CoreData"
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        VStack {
            Text("Choose Methods for Fetching and Saving Data")
                .font(.title2)
                .padding()
            
            // Fetching Methods Buttons
            HStack {
                Button(action: {
                    fetchingMethods = "URLSession"
                }) {
                    Text("URLSession")
                }
                .frame(width: 150, height: 50)
                .background(fetchingMethods == "URLSession" ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(20)
                
                Button(action: {
                    fetchingMethods = "Alamofire"
                }) {
                    Text("Alamofire")
                }
                .frame(width: 150, height: 50)
                .background(fetchingMethods == "Alamofire" ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(20)
            }
            
            // Saving Methods Buttons
            HStack {
                Button(action: {
                    savingMethods = "NSCache"
                }) {
                    Text("NSCache")
                        .font(.caption)
                }
                .frame(width: 100, height: 50)
                .background(savingMethods == "NSCache" ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(20)
                
                Button(action: {
                    savingMethods = "CoreData"
                }) {
                    Text("CoreData")
                        .font(.caption)
                }
                .frame(width: 100, height: 50)
                .background(savingMethods == "CoreData" ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(20)
                
                Button(action: {
                    savingMethods = "UserDefaults"
                }) {
                    Text("UserDefaults")
                        .font(.caption)
                }
                .frame(width: 100, height: 50)
                .background(savingMethods == "UserDefaults" ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(20)
            }
            
            // Submit Button
            Button(action: {
                handleSubmit()
            }) {
                Text("Submit")
                    .font(.title3)
                    .bold()
            }
            .frame(width: 300, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding()
            
            // Information Display
            Text("Data fetched using \(fetchingMethods) and saved using \(savingMethods)")
                .frame(width: 350, height: 50)
                .border(Color.black)
                .padding()
            
            // ScrollView Placeholder
            ScrollView {
                VStack {
                    ForEach(viewModel.getUsers(), id: \.self) { user in
                        VStack(alignment: .leading) {
                            Text("Username: \(user.username ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
            }
        }
        .padding()
    }
}

extension OptionView {
    private func handleSubmit() {
        Task {
            updateViewModel()
            fetchData()
        }
    }
    
    private func updateViewModel() {
        let networkSession: NetworkSession
        switch fetchingMethods {
        case "URLSession":
            networkSession = URLSessionManager()
        case "Alamofire":
            networkSession = AlamofireManager()
        default:
            networkSession = URLSessionManager()
        }
        
        let storageOption: UserViewModel.StorageOption
        switch savingMethods {
        case "NSCache":
            storageOption = .nsCache
        case "CoreData":
            storageOption = .coreData
        case "UserDefaults":
            storageOption = .userDefaults
        default:
            storageOption = .coreData
        }
        
        DispatchQueue.main.async {
            viewModel.setApiManager(networkSession)
            viewModel.setStorageOption(storageOption)
        }
    }
    
    private func fetchData() {
        viewModel.fetchUsers(from: Common.urlString.rawValue) {
        }
    }
}

#Preview {
    OptionView()
}
