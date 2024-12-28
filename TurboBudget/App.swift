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
    @StateObject private var userRepository: UserStore = .shared
    @StateObject private var accountRepository: AccountStore = .shared
    @StateObject private var categoryRepository: CategoryStore = .shared
    @StateObject private var transactionRepository: TransactionStore = .shared
    @StateObject private var transferRepository: TransferStore = .shared
    @StateObject private var subscriptionRepository: SubscriptionStore = .shared
    @StateObject private var savingsPlanRepository: SavingsPlanStore = .shared
    @StateObject private var contributionRepository: ContributionStore = .shared
    @StateObject private var budgetRepository: BudgetStore = .shared
    @StateObject private var creditCardRepository: CreditCardStore = .shared
    
    // Repository
    @StateObject private var accountRepo: AccountRepositoryOld = .shared
    @StateObject private var transactionRepo: TransactionRepositoryOld = .shared
    @StateObject private var automationRepo: AutomationRepositoryOld = .shared
    @StateObject private var savingPlanRepo: SavingPlanRepositoryOld = .shared
    @StateObject private var budgetRepo: BudgetRepositoryOld = .shared
    
    @StateObject private var filterManager: FilterManager = .shared
    @StateObject private var successfullModalManager: SuccessfullModalManager = .shared
    
    // Environment
    @Environment(\.scenePhase) private var scenePhase
    
    // Preferences
    @StateObject private var preferencesSecurity: PreferencesSecurity = .shared
    @StateObject private var preferencesSubscription: PreferencesSubscription = .shared
    
    @State private var isStartDataLoaded: Bool = false
    
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
                        if !isStartDataLoaded {
                            await accountRepository.fetchAccounts()
                            accountRepository.selectedAccount = accountRepository.mainAccount
                            if let mainAccount = accountRepository.mainAccount, let accountID = mainAccount.id {
                                await transactionRepository.fetchTransactionsOfCurrentMonth(accountID: accountID)
                                await subscriptionRepository.fetchSubscriptions(accountID: accountID)
                                await savingsPlanRepository.fetchSavingsPlans(accountID: accountID)
                                await budgetRepository.fetchBudgets(accountID: accountID)
                                await creditCardRepository.fetchCreditCards(accountID: accountID)
                                
                                if preferencesSubscription.isNotificationsEnabled {
                                    for subscription in subscriptionRepository.subscriptions {
                                        guard let subscriptionID = subscription.id else { continue }
                                        
                                        await NotificationsManager.shared.scheduleNotification(
                                            for: .init(
                                                id: subscriptionID,
                                                title: "CashFlow",
                                                message: subscription.notifMessage,
                                                date: subscription.dateNotif
                                            ),
                                            daysBefore: preferencesSubscription.dayBeforeReceiveNotification
                                        )
                                    }
                                }
                            }
                            isStartDataLoaded = true
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
            .environmentObject(userRepository)
            .environmentObject(accountRepository)
            .environmentObject(categoryRepository)
            .environmentObject(transactionRepository)
            .environmentObject(transferRepository)
            .environmentObject(subscriptionRepository)
            .environmentObject(savingsPlanRepository)
            .environmentObject(contributionRepository)
            .environmentObject(budgetRepository)
            .environmentObject(creditCardRepository)
            
            // Old Repository
            .environmentObject(accountRepo)
            .environmentObject(transactionRepo)
            .environmentObject(automationRepo)
            .environmentObject(savingPlanRepo)
            .environmentObject(budgetRepo)
            
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
                    try await userRepository.loginWithToken()
                    appManager.viewState = .success
                } catch {
                    appManager.viewState = .failed
                }
            }
        }
    } // body
} // struct
