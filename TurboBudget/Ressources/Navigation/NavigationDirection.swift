//
//  NavigationDirection.swift
//  Krabs
//
//  Created by Theo Sementa on 05/12/2023.
//

import Foundation
import SwiftUI

enum NavigationDirection: Identifiable {
    case pageController
    case filter
    
    case home(account: Account)
    case homeSavingPlans
    case homeAutomations
    
    case analytics
    
    case createAccount(type: AccountType)
    case createBudget
    case createSavingsPlan(savingsPlan: SavingsPlanModel? = nil)
    case createContribution(savingsPlan: SavingsPlanModel)
    case createTransaction(transaction: TransactionModel? = nil)
    case createSubscription(subscription: SubscriptionModel? = nil)
    case createTransfer(receiverAccount: AccountModel? = nil)
        
    case selectCategory(category: Binding<CategoryModel?>, subcategory: Binding<SubcategoryModel?>)
    
    case allTransactions
    case transactionDetail(transaction: TransactionModel)
    
    case savingPlansDetail(savingsPlan: SavingsPlanModel)
    
    case accountDashboard
    case allSavingsAccount
    case savingsAccountDetail(savingsAccount: AccountModel)
    case allBudgets
    case budgetTransactions(subcategory: SubcategoryModel)
    case allArchivedSavingPlans(account: Account)
    
    case homeCategories
    case categoryTransactions(category: CategoryModel)
    case homeSubcategories(category: CategoryModel)
    case subcategoryTransactions(subcategory: SubcategoryModel)

    case whatsNew
    case paywall
    
    case settings
    case settingsDebug
    case settingsGeneral
    case settingsSecurity
    case settingsAppearence
    case settingsDisplay
    case settingsAccount
    case settingsSavingPlans
    case settingsSubscription
    case settingsBudget
    case settingsCredits
    
    var id: Self { self }
}

extension NavigationDirection: Equatable {
    static func == (lhs: NavigationDirection, rhs: NavigationDirection) -> Bool {
        switch (lhs, rhs) {
        case (.pageController, .pageController),
            (.filter, .filter),
            (.allSavingsAccount, .allSavingsAccount),
            (.allBudgets, .allBudgets),
            (.homeCategories, .homeCategories),
            (.homeSavingPlans, .homeSavingPlans),
            (.homeAutomations, .homeAutomations),
            (.analytics, .analytics),
            (.transactionDetail, .transactionDetail),
            (.savingPlansDetail, .savingPlansDetail),
            (.allTransactions, .allTransactions),
            (.createAccount, .createAccount),
            (.createSubscription, .createSubscription),
            (.createBudget, .createBudget),
            (.createSavingsPlan, .createSavingsPlan),
            (.createContribution, .createContribution),
            (.createTransaction, .createTransaction),
            (.createTransfer, .createTransfer),
            (.accountDashboard, .accountDashboard),
            (.paywall, .paywall),
            (.whatsNew, .whatsNew),
            (.settings, .settings),
            (.settingsDebug, .settingsDebug),
            (.settingsGeneral, .settingsGeneral),
            (.settingsSecurity, .settingsSecurity),
            (.settingsAppearence, .settingsAppearence),
            (.settingsDisplay, .settingsDisplay),
            (.settingsAccount, .settingsAccount),
            (.settingsSavingPlans, .settingsSavingPlans),
            (.settingsSubscription, .settingsSubscription),
            (.settingsBudget, .settingsBudget),
            (.settingsCredits, .settingsCredits):
            return true
            
        case let (.home(lhsAccount), .home(rhsAccount)):
            return lhsAccount.id == rhsAccount.id
            
        case let (.selectCategory(lhsCategory, lhsSubcategory), .selectCategory(rhsCategory, rhsSubcategory)):
            return (lhsCategory.wrappedValue?.id == rhsCategory.wrappedValue?.id) && (lhsSubcategory.wrappedValue?.id == rhsSubcategory.wrappedValue?.id)
            
        case let (.savingsAccountDetail(lhsSavingsAccount), .savingsAccountDetail(rhsSavingsAccount)):
            return lhsSavingsAccount.id == rhsSavingsAccount.id
            
        case let (.allArchivedSavingPlans(lhsAccount), .allArchivedSavingPlans(rhsAccount)):
            return lhsAccount.id == rhsAccount.id
            
        case let (.budgetTransactions(lhsSubcategory), .budgetTransactions(rhsSubcategory)):
            return lhsSubcategory.id == rhsSubcategory.id
            
            
        case let (.categoryTransactions(lhsCategory), .categoryTransactions(rhsCategory)):
            return lhsCategory.id == rhsCategory.id
            
        case let (.homeSubcategories(lhsCategory), .homeSubcategories(rhsCategory)):
            return lhsCategory.id == rhsCategory.id
            
        case let (.subcategoryTransactions(lhsSubcategory), .subcategoryTransactions(rhsSubcategory)):
            return lhsSubcategory.id == rhsSubcategory.id
            
        default:
            return false
        }
    }
}

extension NavigationDirection: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
