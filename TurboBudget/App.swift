//
//  TurboBudgetApp.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import SwiftUI
import AlertKit
import NotificationKit

@main
struct TurboBudgetApp: App {
    
    // Custom type
    @StateObject private var appManager: AppManager = .shared
    @StateObject private var csManager = ColorSchemeManager()
    @StateObject private var purchasesManager = PurchasesManager()
    @StateObject private var alertManager: AlertManager = .shared
    @StateObject private var themeManager: ThemeManager = .shared
    @StateObject private var modalManager: ModalManager = .shared
    @StateObject private var router: NavigationManager = NavigationManager(isPresented: .constant(.pageController))
    
    // New Repository
    @StateObject private var userStore: UserStore = .shared
    @StateObject private var accountStore: AccountStore = .shared
    @StateObject private var categoryStore: CategoryStore = .shared
    @StateObject private var transactionStore: TransactionStore = .shared
    @StateObject private var transferStore: TransferStore = .shared
    @StateObject private var subscriptionStore: SubscriptionStore = .shared
    @StateObject private var savingsPlanStore: SavingsPlanStore = .shared
    @StateObject private var contributionStore: ContributionStore = .shared
    @StateObject private var budgetStore: BudgetStore = .shared
    @StateObject private var creditCardStore: CreditCardStore = .shared
    
    @StateObject private var filterManager: FilterManager = .shared
    @StateObject private var successfullModalManager: SuccessfullModalManager = .shared
    
    // Environment
    @Environment(\.scenePhase) private var scenePhase
    
    // Preferences
    @StateObject private var preferencesSecurity: PreferencesSecurity = .shared
    @StateObject private var preferencesSubscription: PreferencesSubscription = .shared
        
    // init
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: nameFontBold, size: 18)!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: nameFontBold, size: 30)!]
    }
    
    // MARK: -
    var body: some Scene {
        WindowGroup {
            NavStack(router: router) {
                switch appManager.viewState {
                case .idle:
                    SplashScreenView()
                case .loading:
                    SplashScreenView()
                case .success:
                    Group {
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
                        if !appManager.isStartDataLoaded {
                            await accountStore.fetchAccounts()
                            await appManager.loadStartData()
                            appManager.isStartDataLoaded = true
                        }
                    }
                case .syncing:
                    SyncingView()
                case .notSynced:
                    NotSyncedView()
                case .failed:
                    LoginView()
                }
            }
            .blur(radius: appManager.isMenuPresented ? 12 : 0)
            .overlay {
                if appManager.isMenuPresented {
                    CreationMenuView()
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
            .environmentObject(alertManager)
            .environmentObject(modalManager)
            .environmentObject(themeManager)
            
            // New Repository
            .environmentObject(userStore)
            .environmentObject(accountStore)
            .environmentObject(categoryStore)
            .environmentObject(transactionStore)
            .environmentObject(transferStore)
            .environmentObject(subscriptionStore)
            .environmentObject(savingsPlanStore)
            .environmentObject(contributionStore)
            .environmentObject(budgetStore)
            .environmentObject(creditCardStore)
            
            .environmentObject(filterManager)
            .environmentObject(successfullModalManager)
            .onAppear {
                UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                csManager.applyColorScheme()
                
                // OLD COREDATA
                AccountRepositoryOld.shared.fetchMainAccount()
                TransactionRepositoryOld.shared.fetchTransactions()
                AutomationRepositoryOld.shared.fetchAutomations()
                SavingPlanRepositoryOld.shared.fetchSavingsPlans()
                BudgetRepositoryOld.shared.fetchBudgets()
                // END OLD COREDATA
            }
            .alert(alertManager)
            .sheet(isPresented: $modalManager.isPresented, onDismiss: { modalManager.isPresented = false }) {
                if let view = modalManager.content {
                    AnyView(view)
                        .padding(24)
                        .onGetHeight { height in
                            self.modalManager.currentHeight = height
                        }
                        .presentationDetents([.height(modalManager.currentHeight)])
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .task {
                await purchasesManager.loadProducts()
                
                do {
                    try await userStore.loginWithToken()
                    appManager.viewState = .success
                } catch {
                    appManager.viewState = .failed
                }
            }
        }
    } // body
} // struct
