//
//  TurboBudgetApp.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import SwiftUI

@main
struct TurboBudgetApp: App {
    
    // CoreData
    let persistenceController = PersistenceController.shared
    
    // Custom type
//    @StateObject private var router: NavigationManager = NavigationManager(isPresented: .constant(.home))
    @StateObject private var csManager = ColorSchemeManager()
    @StateObject private var store = Store()
    
    // Environment
    @Environment(\.scenePhase) private var scenePhase
    
    // Preferences
    @Preference(\.isSecurityPlusEnabled) private var isSecurityPlusEnabled
    
    // init
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: nameFontBold, size: 18)!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: nameFontBold, size: 30)!]
    }
    
    //MARK: - body
    var body: some Scene {
        WindowGroup {
//            NavStack(router: router) {
                if isSecurityPlusEnabled {
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
//            .onAppear {
//                store.restorePurchases()
//            }
//        }
    } // End body
} // End struct
