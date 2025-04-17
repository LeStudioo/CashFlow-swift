//
//  AppDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum AppDestination: AppDestinationProtocol {
    case account(AccountDestination)
    case savingsAccount(SavingsAccountDestination)
    case transaction(TransactionDestination)
    case subscription(SubscriptionDestination)
    case savingsPlan(SavingsPlanDestination)
    case settings(SettingsDestination)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .account(let accountDestination):
            accountDestination.body(route: route)
        case .savingsAccount(let savingsAccountDestination):
            savingsAccountDestination.body(route: route)
        case .transaction(let transactionDestination):
            transactionDestination.body(route: route)
        case .subscription(let subscriptionDestination):
            subscriptionDestination.body(route: route)
        case .savingsPlan(let savingsPlanDestination):
            savingsPlanDestination.body(route: route)
        case .settings(let settingsDestination):
            settingsDestination.body(route: route)
        }
    }
}
