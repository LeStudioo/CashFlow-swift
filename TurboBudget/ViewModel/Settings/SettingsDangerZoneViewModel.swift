//
//  SettingsDangerZoneViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import Foundation

final class SettingsDangerZoneViewModel: ObservableObject {
    
    @Published var info: MultipleAlert? = nil
    
    @Preference(\.hapticFeedback) var hapticFeedback
    
    @Preference(\.isFaceIDEnabled) var isFaceIDEnabled
    @Preference(\.isSecurityPlusEnabled) var isSecurityPlusEnabled
        
    @Preference(\.isSavingPlansDisplayedHomeScreen) var isSavingPlansDisplayedHomeScreen
    @Preference(\.numberOfSavingPlansDisplayedInHomeScreen) var numberOfSavingPlansDisplayedInHomeScreen
    @Preference(\.isAutomationsDisplayedHomeScreen) var isAutomationsDisplayedHomeScreen
    @Preference(\.numberOfAutomationsDisplayedInHomeScreen) var numberOfAutomationsDisplayedInHomeScreen
    @Preference(\.isRecentTransactionsDisplayedHomeScreen) var isRecentTransactionsDisplayedHomeScreen
    @Preference(\.numberOfRecentTransactionDisplayedInHomeScreen) var numberOfRecentTransactionDisplayedInHomeScreen
    
    @Preference(\.accountCanBeNegative) var accountCanBeNegative
    @Preference(\.blockExpensesIfCardLimitExceeds) var blockExpensesIfCardLimitExceeds
    @Preference(\.cardLimitPercentage) var cardLimitPercentage
    
    @Preference(\.automatedArchivedSavingPlan) var automatedArchivedSavingPlan
    @Preference(\.numberOfDayForArchivedSavingPlan) var numberOfDayForArchivedSavingPlan
    
    @Preference(\.blockExpensesIfBudgetAmountExceeds) var blockExpensesIfBudgetAmountExceeds
    @Preference(\.budgetPercentage) var budgetPercentage
}

extension SettingsDangerZoneViewModel {
    
    func resetSettings() {
        
        // Setting - General
        hapticFeedback = true
        
        // Setting - Security
        isFaceIDEnabled = false
        isSecurityPlusEnabled = false
        
        // Setting - Display
        isAutomationsDisplayedHomeScreen = true
        numberOfAutomationsDisplayedInHomeScreen = 2
        
        isSavingPlansDisplayedHomeScreen = true
        numberOfSavingPlansDisplayedInHomeScreen = 4
        
        isRecentTransactionsDisplayedHomeScreen = true
        numberOfRecentTransactionDisplayedInHomeScreen = 5
        
        // Setting - Appearance
        ThemeManager.theme = .green
        
        // Setting - Account
        accountCanBeNegative = false
        blockExpensesIfCardLimitExceeds = true
        cardLimitPercentage = 80
        
        // Setting - Saving Plan
        automatedArchivedSavingPlan = false
        numberOfDayForArchivedSavingPlan = 30
        
        // Setting - Budgets
        blockExpensesIfBudgetAmountExceeds = true
        budgetPercentage = 80
        
    }
    
}
