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
    
    case home(account: Account)
    case homeSavingPlans
    case homeAutomations
    
    case analytics
    case transactionsForMonth(month: Date, type: TransactionType)
    
    case createAccount(type: AccountType, account: AccountModel? = nil)
    case createBudget
    case createSavingsPlan(savingsPlan: SavingsPlanModel? = nil)
    case createContribution(savingsPlan: SavingsPlanModel)
    case createTransaction(transaction: TransactionModel? = nil)
    case createSubscription(subscription: SubscriptionModel? = nil)
    case createTransfer(receiverAccount: AccountModel? = nil)
    case createCreditCard
    case createTransactionForSavingsAccount(savingsAccount: AccountModel, transaction: TransactionModel? = nil)
    case qrCodeScanner
        
    case selectCategory(category: Binding<CategoryModel?>, subcategory: Binding<SubcategoryModel?>)
    
    case allTransactions
    case transactionDetail(transaction: TransactionModel)
    
    case savingPlansDetail(savingsPlan: SavingsPlanModel)
    
    case subscriptionDetail(subscription: SubscriptionModel)
    
    case accountDashboard
    case accountStatistics
    case allSavingsAccount
    case savingsAccountDetail(savingsAccount: AccountModel)
    case allBudgets
    case budgetTransactions(subcategory: SubcategoryModel)
    case allArchivedSavingPlans(account: Account)
    
    case homeCategories
    case categoryTransactions(category: CategoryModel, selectedDate: Date)
    case homeSubcategories(category: CategoryModel, selectedDate: Date)
    case subcategoryTransactions(subcategory: SubcategoryModel, selectedDate: Date)

    case whatsNew
    case paywall
    
    case settings
    case settingsDebug
    case settingsGeneral
    case settingsSecurity
    case settingsAppearence
    case settingsDisplay
    case settingsSubscription
    case settingsCredits
    case settingsApplePay
    
    var id: Self { self }
}

extension NavigationDirection: Equatable {
    static func == (lhs: NavigationDirection, rhs: NavigationDirection) -> Bool {
        switch (lhs, rhs) {
        case (.pageController, .pageController),
            (.allSavingsAccount, .allSavingsAccount),
            (.allBudgets, .allBudgets),
            (.home, .home),
            (.homeCategories, .homeCategories),
            (.homeSubcategories, .homeSubcategories),
            (.categoryTransactions, .categoryTransactions),
            (.subcategoryTransactions, .subcategoryTransactions),
            (.budgetTransactions, .budgetTransactions),
            (.homeSavingPlans, .homeSavingPlans),
            (.homeAutomations, .homeAutomations),
            (.savingsAccountDetail, .savingsAccountDetail),
            (.analytics, .analytics),
            (.transactionsForMonth, .transactionsForMonth),
            (.transactionDetail, .transactionDetail),
            (.savingPlansDetail, .savingPlansDetail),
            (.subscriptionDetail, .subscriptionDetail),
            (.allTransactions, .allTransactions),
            (.createAccount, .createAccount),
            (.createSubscription, .createSubscription),
            (.createBudget, .createBudget),
            (.createSavingsPlan, .createSavingsPlan),
            (.createContribution, .createContribution),
            (.createTransaction, .createTransaction),
            (.createTransfer, .createTransfer),
            (.createCreditCard, .createCreditCard),
            (.createTransactionForSavingsAccount, .createTransactionForSavingsAccount),
            (.qrCodeScanner, .qrCodeScanner),
            (.selectCategory, .selectCategory),
            (.accountDashboard, .accountDashboard),
            (.accountStatistics, .accountStatistics),
            (.allArchivedSavingPlans, .allArchivedSavingPlans),
            (.paywall, .paywall),
            (.whatsNew, .whatsNew),
            (.settings, .settings),
            (.settingsDebug, .settingsDebug),
            (.settingsGeneral, .settingsGeneral),
            (.settingsSecurity, .settingsSecurity),
            (.settingsAppearence, .settingsAppearence),
            (.settingsDisplay, .settingsDisplay),
            (.settingsSubscription, .settingsSubscription),
            (.settingsApplePay, .settingsApplePay),
            (.settingsCredits, .settingsCredits):
            return true
            
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
