//
//  SwiftUIDependencyInjectionApp.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import SwiftUI
import CoreData

@main
struct SwiftUIDependencyInjectionApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
