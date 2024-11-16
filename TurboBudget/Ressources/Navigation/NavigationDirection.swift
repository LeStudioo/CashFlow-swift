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
    
    case createAccount
    case createAutomation
    case createBudget
    case createSavingPlans
    case createTransaction
    case recoverTransaction
    case createSavingsAccount
    case createTransfer
        
    case selectCategory(category: Binding<PredefinedCategory?>, subcategory: Binding<PredefinedSubcategory?>)
    
    case allTransactions
    case transactionDetail(transaction: TransactionModel)
    
    case savingPlansDetail(savingPlan: SavingPlan)
    
    case accountDashboard
    case allSavingsAccount
    case savingsAccountDetail(savingsAccount: SavingsAccount)
    case allBudgets
    case budgetTransactions(subcategory: PredefinedSubcategory)
    case allArchivedSavingPlans(account: Account)
    
    case homeCategories
    case categoryTransactions(category: PredefinedCategory)
    case homeSubcategories(category: PredefinedCategory)
    case subcategoryTransactions(subcategory: PredefinedSubcategory)

    case paywall
    
    case settings
    case settingsGeneral
    case settingsSecurity
    case settingsAppearence
    case settingsDisplay
    case settingsAccount
    case settingsSavingPlans
    case settingsBudget
    case settingsCredits
    case settingsDangerZone
    
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
            (.allTransactions, .allTransactions),
            (.createAccount, .createAccount),
            (.createAutomation, .createAutomation),
            (.createBudget, .createBudget),
            (.createSavingPlans, .createSavingPlans),
            (.createTransaction, .createTransaction),
            (.recoverTransaction, .recoverTransaction),
            (.createSavingsAccount, .createSavingsAccount),
            (.createTransfer, .createTransfer),
            (.accountDashboard, .accountDashboard),
            (.paywall, .paywall),
            (.settings, .settings),
            (.settingsGeneral, .settingsGeneral),
            (.settingsSecurity, .settingsSecurity),
            (.settingsAppearence, .settingsAppearence),
            (.settingsDisplay, .settingsDisplay),
            (.settingsAccount, .settingsAccount),
            (.settingsSavingPlans, .settingsSavingPlans),
            (.settingsBudget, .settingsBudget),
            (.settingsCredits, .settingsCredits),
            (.settingsDangerZone, .settingsDangerZone):
            return true
            
        case let (.home(lhsAccount), .home(rhsAccount)):
            return lhsAccount.id == rhsAccount.id
            
        case let (.selectCategory(lhsCategory, lhsSubcategory), .selectCategory(rhsCategory, rhsSubcategory)):
            return (lhsCategory.wrappedValue?.id == rhsCategory.wrappedValue?.id) && (lhsSubcategory.wrappedValue?.id == rhsSubcategory.wrappedValue?.id)
            
            
        case let (.savingPlansDetail(lhsSavingPlan), .savingPlansDetail(rhsSavingPlan)):
            return lhsSavingPlan.id == rhsSavingPlan.id
            
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
