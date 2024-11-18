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
    @StateObject private var appManager: AppManager = .shared
    @StateObject private var csManager = ColorSchemeManager()
    @StateObject private var purchasesManager = PurchasesManager()
    @StateObject private var router = NavigationManager(isPresented: .constant(.pageController))
    
    // New Repository
    @StateObject private var userRepository: UserRepository = .shared
    @StateObject private var accountRepository: AccountRepository = .shared
    @StateObject private var transactionRepository: TransactionRepository = .shared
    @StateObject private var subscriptionRepository: SubscriptionRepository = .shared
    @StateObject private var savingsPlanRepository: SavingsPlanRepository = .shared
    @StateObject private var contributionRepository: ContributionRepository = .shared
    @StateObject private var budgetRepository: BudgetRepository = .shared
    
    // Repository
    @StateObject private var accountRepo: AccountRepositoryOld = .shared
    @StateObject private var transactionRepo: TransactionRepositoryOld = .shared
    @StateObject private var automationRepo: AutomationRepositoryOld = .shared
    @StateObject private var savingPlanRepo: SavingPlanRepositoryOld = .shared
    @StateObject private var budgetRepo: BudgetRepositoryOld = .shared
    @StateObject private var savingsAccountRepo: SavingsAccountRepositoryOld = .shared

    @StateObject private var filterManager: FilterManager = .shared
    @StateObject private var successfullModalManager: SuccessfullModalManager = .shared
    
    // Environment
    @Environment(\.scenePhase) private var scenePhase
    
    // Preferences
    @StateObject private var preferencesSecurity: PreferencesSecurity = .shared
    
    // init
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: nameFontBold, size: 18)!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: nameFontBold, size: 30)!]
    }
    
    // MARK: -
    var body: some Scene {
        WindowGroup {
            Group {
                switch appManager.viewState {
                case .idle:
                    SplashScreenView()
                case .loading:
                    SplashScreenView()
                case .success:
                    NavStack(router: router) {
                        if preferencesSecurity.isSecurityReinforced {
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
                    .task {
                        await accountRepository.fetchAccounts()
                        accountRepository.selectedAccount = accountRepository.mainAccount
                        if let mainAccount = accountRepository.mainAccount, let accountID = mainAccount.id {
                            await transactionRepository.fetchTransactionsWithPagination(accountID: accountID, perPage: 50)
                            await subscriptionRepository.fetchSubscriptions(accountID: accountID)
                            await savingsPlanRepository.fetchSavingsPlans(accountID: accountID)
                            await budgetRepository.fetchBudgets(accountID: accountID)
                        }
                    }
                case .syncing:
                    Text("Syncing")
                case .notSynced:
                    Text("Not synced")
                case .failed:
                    LoginView()
                }
            }
            .overlay(alignment: .bottom) {
                SuccessfullCreationView()
                    .environmentObject(successfullModalManager)
            }
            .environment(\.managedObjectContext, viewContext)
            .environmentObject(appManager)
            .environmentObject(router)
            .environmentObject(csManager)
            .environmentObject(purchasesManager)
            
            // New Repository
            .environmentObject(accountRepository)
            .environmentObject(transactionRepository)
            .environmentObject(subscriptionRepository)
            .environmentObject(savingsPlanRepository)
            .environmentObject(contributionRepository)
            .environmentObject(budgetRepository)
            
            // Old Repository
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
                
                print(DataForServer.shared.json)
            }
            .task {
                await purchasesManager.loadProducts()
                await purchasesManager.getSubscriptionStatus()
                await purchasesManager.getLifetimeStatus()
                                
                do {
                    try await userRepository.loginWithToken()
                    appManager.viewState = .success
                } catch {
                    appManager.viewState = .failed
                }
            }
        }
    } // End body
} // End struct
