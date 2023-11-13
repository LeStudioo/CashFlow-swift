//
//  TurboBudgetApp.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import SwiftUI

@main
struct TurboBudgetApp: App {
    
    //CoreData
    let persistenceController = PersistenceController.shared
    
    //Link color mode
    @StateObject var csManager = ColorSchemeManager()
    @StateObject private var store = Store()
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    @Environment(\.scenePhase) private var scenePhase
    
    //init
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: nameFontBold, size: 18)!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: nameFontBold, size: 30)!]
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if userDefaultsManager.isSecurityPlusEnable {
                    if scenePhase == .active {
                        PageControllerView()
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                            .environmentObject(csManager)
                            .environmentObject(store)
                            .onAppear {
                                UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                                csManager.applyColorScheme()
                            }
                    } else {
                        Image("LaunchScreen")
                            .resizable()
                            .edgesIgnoringSafeArea([.bottom, .top])
                    }
                } else {
                    PageControllerView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(csManager)
                        .environmentObject(store)
                        .onAppear {
                            UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                            csManager.applyColorScheme()
                        }
                }
            }
            .onAppear {
                store.restorePurchases()
            }
        }
    } // End body
}
