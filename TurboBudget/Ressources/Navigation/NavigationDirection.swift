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
    case homeSavingPlans(account: Account)
    case homeAutomations(account: Account)
    
    case analytics(account: Account)
    
    case createAutomation
    case createBudget
    case createSavingPlans
    case createTransaction
    case recoverTransaction
    case createSavingsAccount
    case createTransfer
    
    case selectCategory(category: Binding<PredefinedCategory?>, subcategory: Binding<PredefinedSubcategory?>)
    
    case allTransactions(account: Account)
    case transactionDetail(transaction: Transaction)
    
    case savingPlansDetail(savingPlan: SavingPlan)
    
    case accountDashboard(account: Account)
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
    
    var id: String {
        switch self {
        case .pageController:
            return "pageController"
        case .filter:
            return "filter"
            
        case .home(let account):
            return "home_\(account.id)"
        case .homeSavingPlans(let account):
            return "homeSavingPlans_\(account.id)"
        case .homeAutomations(let account):
            return "homeAutomations_\(account.id)"
            
        case .analytics(let account):
            return "analytics_\(account.id)"
            
        case .createAutomation:
            return "createAutomation"
        case .createBudget:
            return "createBudget"
        case .createSavingPlans:
            return "createSavingPlans"
        case .createTransaction:
            return "createTransaction"
        case .recoverTransaction:
            return "recoverTransaction"
        case .createSavingsAccount:
            return "createSavingsAccount"
        case .createTransfer:
            return "createTransfer"
            
        case .selectCategory(let category, let subcategory):
            return "selectCategory_\(category.wrappedValue?.id ?? "")_\(subcategory.wrappedValue?.id ?? "")"
            
        case .savingPlansDetail(let savingPlan):
            return "savingPlansDetail_\(savingPlan.id)"
            
        case .allTransactions(let account):
            return "allTransactions_\(account.id)"
        case .transactionDetail(let transaction):
            return "transactionDetail_\(transaction.id)"
            
        case .accountDashboard(let account):
            return "accountDashboard_\(account.id)"
        case .allSavingsAccount:
            return "allSavingsAccount"
        case .savingsAccountDetail(let savingsAccount):
            return "savingsAccountDetail_\(savingsAccount.id)"
        case .allBudgets:
            return "allBudgets"
        case .budgetTransactions(let subcategory):
            return "budgetTransactions_\(subcategory.id)"
        case .allArchivedSavingPlans(let account):
            return "allArchivedSavingPlans_\(account.id)"

        case .homeCategories:
            return "homeCategories"
        case .categoryTransactions(let category):
            return "categoryTransactions_\(category.id)"
        case .homeSubcategories(let category):
            return "homeSubcategories_\(category.id)"
        case .subcategoryTransactions(let subcategory):
            return "subcategoryTransactions_\(subcategory.id)"
            
        case .paywall:
            return "paywall"
            
        case .settings:
            return "settings"
        case .settingsGeneral:
            return "settingsGeneral"
        case .settingsSecurity:
            return "settingsSecurity"
        case .settingsAppearence:
            return "settingsAppearence"
        case .settingsDisplay:
            return "settingsDisplay"
        case .settingsAccount:
            return "settingsAccount"
        case .settingsSavingPlans:
            return "settingsSavingPlans"
        case .settingsBudget:
            return "settingsBudget"
        case .settingsCredits:
            return "settingsCredits"
        case .settingsDangerZone:
            return "settingsDangerZone"
        }
    }
}

extension NavigationDirection: Equatable {
    static func == (lhs: NavigationDirection, rhs: NavigationDirection) -> Bool {
        switch (lhs, rhs) {
        case (.pageController, .pageController),
            (.filter, .filter),
            (.allSavingsAccount, .allSavingsAccount),
            (.allBudgets, .allBudgets),
            (.homeCategories, .homeCategories),
            (.createAutomation, .createAutomation),
            (.createBudget, .createBudget),
            (.createSavingPlans, .createSavingPlans),
            (.createTransaction, .createTransaction),
            (.recoverTransaction, .recoverTransaction),
            (.createSavingsAccount, .createSavingsAccount),
            (.createTransfer, .createTransfer),
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
            
        case let (.homeSavingPlans(lhsAccount), .homeSavingPlans(rhsAccount)):
            return lhsAccount.id == rhsAccount.id
            
        case let (.homeAutomations(lhsAccount), .homeAutomations(rhsAccount)):
            return lhsAccount.id == rhsAccount.id
            
            
        case let (.analytics(lhsAccount), .analytics(rhsAccount)):
            return lhsAccount.id == rhsAccount.id
            
            
        case let (.selectCategory(lhsCategory, lhsSubcategory), .selectCategory(rhsCategory, rhsSubcategory)):
            return (lhsCategory.wrappedValue?.id == rhsCategory.wrappedValue?.id) && (lhsSubcategory.wrappedValue?.id == rhsSubcategory.wrappedValue?.id)
            
            
        case let (.savingPlansDetail(lhsSavingPlan), .savingPlansDetail(rhsSavingPlan)):
            return lhsSavingPlan.id == rhsSavingPlan.id
            

        case let (.allTransactions(lhsAccount), .allTransactions(rhsAccount)):
            return lhsAccount.id == rhsAccount.id
            
        case let (.transactionDetail(lhsTransaction), .transactionDetail(rhsTransaction)):
            if !lhsTransaction.isFault && !rhsTransaction.isFault {
                return lhsTransaction.id == rhsTransaction.id
            } else {
                return false
            }

            
        case let (.accountDashboard(lhsAccount), .accountDashboard(rhsAccount)):
            return lhsAccount.id == rhsAccount.id
            
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
