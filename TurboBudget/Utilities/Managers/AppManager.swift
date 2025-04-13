//
//  AppManager.swift
//  CarKit
//
//  Created by Theo Sementa on 30/10/2024.
//

import Foundation
import NotificationKit

final class AppManager: ObservableObject {
    static let shared = AppManager()
    
    @Published var viewState: ApplicationState = .idle
    
    @Published var selectedTab: Int = 0
    @Published var isMenuPresented: Bool = false
    
    @Published var isStartDataLoaded: Bool = false
}

extension AppManager {
 
    @MainActor
    func loadStartData() async {
        let accountStore: AccountStore = .shared
        let transactionStore: TransactionStore = .shared
        let subscriptionStore: SubscriptionStore = .shared
        let savingsPlanStore: SavingsPlanStore = .shared
        let budgetStore: BudgetStore = .shared
        let creditCardStore: CreditCardStore = .shared
        
        let preferencesSubscription: PreferencesSubscription = .shared
        
        if let selectedAccount = accountStore.selectedAccount, let accountID = selectedAccount.id {
            await transactionStore.fetchTransactionsOfCurrentMonth(accountID: accountID)
            await subscriptionStore.fetchSubscriptions(accountID: accountID)
            await savingsPlanStore.fetchSavingsPlans(accountID: accountID)
            await budgetStore.fetchBudgets(accountID: accountID)
            await creditCardStore.fetchCreditCards(accountID: accountID)
            
            if preferencesSubscription.isNotificationsEnabled {
                for subscription in subscriptionStore.subscriptions {
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
    }
    
    @MainActor
    func resetAllStoresData() {
        let transactionStore: TransactionStore = .shared
        let subscriptionStore: SubscriptionStore = .shared
        let savingsPlanStore: SavingsPlanStore = .shared
        let budgetStore: BudgetStore = .shared
        let creditCardStore: CreditCardStore = .shared
        
        transactionStore.reset()
        subscriptionStore.reset()
        savingsPlanStore.reset()
        budgetStore.reset()
        creditCardStore.reset()
    }
    
}
