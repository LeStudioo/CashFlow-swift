//
//  TurboBudgetApp.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import SwiftUI

@main
struct TurboBudgetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
