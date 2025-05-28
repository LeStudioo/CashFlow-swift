//
//  TurboBudgetApp.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import SwiftUI
import AlertKit
import NotificationKit
import TheoKit

@main
struct TurboBudgetApp: App {
    
    // Custom type
    @StateObject private var appManager: AppManager = .shared
    @StateObject private var appearanceManager = AppearanceManager()
    @StateObject private var purchasesManager = PurchasesManager()
    @StateObject private var alertManager: AlertManager = .shared
    @StateObject private var themeManager: ThemeManager = .shared
    @StateObject private var filterManager: FilterManager = .shared
    @StateObject private var successfullModalManager: SuccessfullModalManager = .shared
    @StateObject private var networkMonitor = NetworkMonitor()
    
    // Stores
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
    
    // Environment
    @Environment(\.scenePhase) private var scenePhase
    
    // Preferences
    @StateObject private var preferencesSecurity: PreferencesSecurity = .shared
    @StateObject private var preferencesSubscription: SubscriptionPreferences = .shared
        
    // init
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: nameFontBold, size: 18)!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: nameFontBold, size: 30)!]
    }
    
    // MARK: -
    var body: some Scene {
        WindowGroup {
            Group {
                switch appManager.appState {
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
                case .needLogin:
                    LoginScreen()
                case .noInternet:
                    NoInternetView()
                }
            }
            .overlay(alignment: .bottom) {
                SuccessfullCreationView()
                    .environmentObject(successfullModalManager)
            }
            .environmentObject(appManager)
            .environmentObject(appearanceManager)
            .environmentObject(purchasesManager)
            .environmentObject(alertManager)
            .environmentObject(themeManager)
            .environmentObject(filterManager)
            .environmentObject(successfullModalManager)
            
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
            
            .preferredColorScheme(appearanceManager.appearance.colorScheme)
            .alert(alertManager)
            .task {
                if !networkMonitor.isConnected {
                    appManager.appState = .noInternet
                    return
                }
                
                await purchasesManager.loadProducts()
                
                do {
                    try await userStore.loginWithToken()
                    if let user = userStore.currentUser, user.isPremium == false, purchasesManager.isCashFlowPro {
                        await UserStore.shared.update(body: .init(isPremium: true))
                    }
                    appManager.appState = .success
                } catch {
                    appManager.appState = .needLogin
                }
            }
            .onChange(of: networkMonitor.isConnected) { newValue in
                Task {
                    if newValue {
                        try await userStore.loginWithToken()
                        appManager.appState = .success
                    } else {
                        appManager.appState = .noInternet
                    }
                }
            }
            .onAppear {
                TKDesignSystem.fontBold = "Satoshi-Bold"
                TKDesignSystem.fontMedium = "Satoshi-Medium"
                TKDesignSystem.fontRegular = "Satoshi-Regular"
            }
        }
    } // body
} // struct
