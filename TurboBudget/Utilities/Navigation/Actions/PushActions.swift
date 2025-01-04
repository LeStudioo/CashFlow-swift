//
//  PushActions.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/01/2025.
//

import Foundation

extension NavigationManager {
    
    func pushHome(account: Account) {
        navigateTo(.home(account: account))
    }
    
    func pushHomeSavingPlans() {
        navigateTo(.homeSavingPlans)
    }
    
    func pushHomeAutomations() {
        navigateTo(.homeAutomations)
    }
    
    func pushAnalytics() {
        navigateTo(.analytics)
    }
    
    func pushAllTransactions() {
        navigateTo(.allTransactions)
    }
    
    func pushTransactionDetail(transaction: TransactionModel) {
        navigateTo(.transactionDetail(transaction: transaction))
    }
    
    func pushSavingPlansDetail(savingsPlan: SavingsPlanModel) {
        navigateTo(.savingPlansDetail(savingsPlan: savingsPlan))
    }
    
    func pushAccountDashboard() {
        navigateTo(.accountDashboard)
    }
    
    func pushAccountStatistics() {
        navigateTo(.accountStatistics)
    }
    
    func pushSavingsAccountDetail(savingsAccount: AccountModel) {
        navigateTo(.savingsAccountDetail(savingsAccount: savingsAccount))
    }
    
    func pushSubscriptionDetail(subscription: SubscriptionModel) {
        navigateTo(.subscriptionDetail(subscription: subscription))
    }
    
    func pushAllSavingsAccount() {
        navigateTo(.allSavingsAccount)
    }
    
    func pushAllBudgets() {
        navigateTo(.allBudgets)
    }
    
    func pushTransactionsForMonth(month: Date, type: TransactionType) {
        navigateTo(.transactionsForMonth(month: month, type: type))
    }
    
    func pushBudgetTransactions(subcategory: SubcategoryModel) {
        navigateTo(.budgetTransactions(subcategory: subcategory))
    }
    
    func pushArchivedSavingPlans(account: Account) {
        navigateTo(.allArchivedSavingPlans(account: account))
    }
    
    func pushHomeCategories() {
        navigateTo(.homeCategories)
    }
    
    func pushCategoryTransactions(category: CategoryModel, selectedDate: Date) {
        navigateTo(.categoryTransactions(category: category, selectedDate: selectedDate))
    }
    
    func pushHomeSubcategories(category: CategoryModel, selectedDate: Date) {
        navigateTo(.homeSubcategories(category: category, selectedDate: selectedDate))
    }
    
    func pushSubcategoryTransactions(subcategory: SubcategoryModel, selectedDate: Date) {
        navigateTo(.subcategoryTransactions(subcategory: subcategory, selectedDate: selectedDate))
    }
    
    func pushSettings() {
        navigateTo(.settings)
    }
    
    func pushSettingsDebug() {
        navigateTo(.settingsDebug)
    }
    
    func pushSettingsGeneral() {
        navigateTo(.settingsGeneral)
    }
    
    func pushSettingsSecurity() {
        navigateTo(.settingsSecurity)
    }
    
    func pushSettingsAppearence() {
        navigateTo(.settingsAppearence)
    }
    
    func pushSettingsDisplay() {
        navigateTo(.settingsDisplay)
    }
    
    func pushSettingsSubscription() {
        navigateTo(.settingsSubscription)
    }
    
    func pushSettingsCredits() {
        navigateTo(.settingsCredits)
    }
    
    func pushSettingsApplePay() {
        navigateTo(.settingsApplePay)
    }
    
}
