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
    case transfer(TransferDestination)
    case transaction(TransactionDestination)
    case subscription(SubscriptionDestination)
    case savingsPlan(SavingsPlanDestination)
    case contribution(ContributionDestination)
    case budget(BudgetsDestination)
    case creditCard(CreditCardDestination)
    case category(CategoryDestination)
    case subcategory(SubcategoryDestination)
    
    case settings(SettingsDestination)
    case shared(SharedDestination)
    case tips(TipsDestination)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .account(let accountDestination):
            accountDestination.body(route: route)
        case .savingsAccount(let savingsAccountDestination):
            savingsAccountDestination.body(route: route)
        case .transfer(let transferDestination):
            transferDestination.body(route: route)
        case .transaction(let transactionDestination):
            transactionDestination.body(route: route)
        case .subscription(let subscriptionDestination):
            subscriptionDestination.body(route: route)
        case .savingsPlan(let savingsPlanDestination):
            savingsPlanDestination.body(route: route)
        case .contribution(let contributionDestination):
            contributionDestination.body(route: route)
        case .budget(let budgetDestination):
            budgetDestination.body(route: route)
        case .creditCard(let creditCardDestination):
            creditCardDestination.body(route: route)
        case .category(let categoryDestination):
            categoryDestination.body(route: route)
        case .subcategory(let subcategoryDestination):
            subcategoryDestination.body(route: route)
            
        case .settings(let settingsDestination):
            settingsDestination.body(route: route)
        case .shared(let sharedDestination):
            sharedDestination.body(route: route)
        case .tips(let tipsDestination):
            tipsDestination.body(route: route)
        }
    }
}
