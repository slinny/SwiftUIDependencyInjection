//
//  ContentView.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        OptionView()
            .environment(\.managedObjectContext, viewContext)
    }
}


#Preview {
    ContentView()
}
