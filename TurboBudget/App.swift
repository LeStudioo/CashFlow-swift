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
    @StateObject private var purchasesManager = PurchasesManager()
    @StateObject private var router = NavigationManager(isPresented: .constant(.pageController))
    
    // Repository
    @StateObject private var accountRepo: AccountRepositoryOld = .shared
    @StateObject private var transactionRepo: TransactionRepositoryOld = .shared
    @StateObject private var automationRepo: AutomationRepository = .shared
    @StateObject private var savingPlanRepo: SavingPlanRepositoryOld = .shared
    @StateObject private var budgetRepo: BudgetRepository = .shared
    @StateObject private var savingsAccountRepo: SavingsAccountRepo = .shared

    @StateObject private var filterManager: FilterManager = .shared
    @StateObject private var successfullModalManager: SuccessfullModalManager = .shared
    
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
            .environmentObject(purchasesManager)
            
            .environmentObject(accountRepo)
            .environmentObject(transactionRepo)
            .environmentObject(automationRepo)
            .environmentObject(savingPlanRepo)
            .environmentObject(budgetRepo)
            .environmentObject(savingsAccountRepo)
            
            .environmentObject(filterManager)
            .environmentObject(successfullModalManager)
            .onAppear {
                UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                csManager.applyColorScheme()
               
                accountRepo.fetchMainAccount()
                transactionRepo.fetchTransactions()
                automationRepo.fetchAutomations()
                savingPlanRepo.fetchSavingsPlans()
                budgetRepo.fetchBudgets()
//                savingsAccountRepo.fetchSavingsAccounts()
                
                print(DataForServer.shared.json)
            }
            .task {
                await purchasesManager.loadProducts()
                await purchasesManager.getSubscriptionStatus()
                await purchasesManager.getLifetimeStatus()
            }
        }
    } // End body
} // End struct
