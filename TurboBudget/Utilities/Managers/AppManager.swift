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
    
    @Published var appState: ApplicationState = .idle
    
    @Published var selectedTab: Int = 0
    @Published var isMenuPresented: Bool = false
    
    @Published var isStartDataLoaded: Bool = false
    @Published var isRoutersRegistered: Bool = false
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
        let categoryStore: CategoryStore = .shared
        
        let preferencesSubscription: SubscriptionPreferences = .shared
        
        await categoryStore.fetchCategories()
        if let selectedAccount = accountStore.selectedAccount, let accountID = selectedAccount._id {
            await transactionStore.fetchTransactionsOfCurrentMonth(accountID: accountID)
            await subscriptionStore.fetchSubscriptions(accountID: accountID)
            await savingsPlanStore.fetchSavingsPlans(accountID: accountID)
            await budgetStore.fetchBudgets(accountID: accountID)
            await creditCardStore.fetchCreditCards(accountID: accountID)
            
            if preferencesSubscription.isNotificationsEnabled {
                for subscription in subscriptionStore.subscriptions {                    
                    await NotificationsManager.shared.scheduleNotification(
                        for: .init(
                            id: "\(subscription.id)",
                            title: "CashFlow",
                            message: subscription.notifMessage,
                            date: subscription.dateNotif
                        ),
                        daysBefore: preferencesSubscription.dayBeforeReceiveNotification
                    )
                }
                
                await NotificationsManager.shared.removePendingNotification(for: "notification-oneWeekLater")
                await NotificationsManager.shared.removePendingNotification(for: "notification-twoWeekLater")
                
                await NotificationsManager.shared.scheduleNotification(
                    for: .init(
                        id: "notification-oneWeekLater",
                        title: "CashFlow",
                        message: "notification_one_week_later_message".localized,
                        date: Date().oneWeekLater
                    ),
                    daysBefore: 0
                )
                
                await NotificationsManager.shared.scheduleNotification(
                    for: .init(
                        id: "notification-twoWeekLater",
                        title: "CashFlow",
                        message: "notification_two_week_later_message".localized,
                        date: Date().twoWeekLater
                    ),
                    daysBefore: 0
                )
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
        let categoryStore: CategoryStore = .shared
        
        transactionStore.reset()
        subscriptionStore.reset()
        savingsPlanStore.reset()
        budgetStore.reset()
        creditCardStore.reset()
        categoryStore.reset()
    }
    
}
