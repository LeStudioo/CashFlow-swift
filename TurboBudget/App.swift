//
//  TurboBudgetApp.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import SwiftUI

@main
struct TurboBudgetApp: App {
    
    // Custom type
    @StateObject private var csManager = ColorSchemeManager()
    @StateObject private var store = Store()
    @StateObject private var router = NavigationManager(isPresented: .constant(.pageController))
    
    // Repository
    @StateObject private var accountRepo: AccountRepository = .shared
    @StateObject private var transactionRepo: TransactionRepository = .shared
    @StateObject private var savingPlanRepo: SavingPlanRepository = .shared
    @StateObject private var budgetRepo: BudgetRepository = .shared
    
    // Environment
    @Environment(\.scenePhase) private var scenePhase
    
    // Preferences
    @Preference(\.isSecurityPlusEnabled) private var isSecurityPlusEnabled
    
    // init
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: nameFontBold, size: 18)!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: nameFontBold, size: 30)!]
    }
    
    // MARK: -
    var body: some Scene {
        WindowGroup {
            NavStack(router: router) {
                if isSecurityPlusEnabled {
                    if scenePhase == .active {
                        PageControllerView()
                    } else {
                        Image("LaunchScreen")
                            .resizable()
                            .edgesIgnoringSafeArea([.bottom, .top])
                    }
                } else {
                    PageControllerView()
                }
            }
            .environment(\.managedObjectContext, viewContext)
            .environmentObject(router)
            .environmentObject(csManager)
            .environmentObject(store)
            
            .environmentObject(accountRepo)
            .environmentObject(transactionRepo)
            .environmentObject(savingPlanRepo)
            .environmentObject(budgetRepo)
            .onAppear {
                UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                csManager.applyColorScheme()
                store.restorePurchases()
                
                accountRepo.fetchMainAccount()
                transactionRepo.fetchTransactions()
                savingPlanRepo.fetchSavingPlans()
                budgetRepo.fetchBudgets()
            }
        }
    } // End body
} // End struct
