//
//  SettingsDangerZoneViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import Foundation

final class SettingsDangerZoneViewModel: ObservableObject {
    
    @Published var info: MultipleAlert? = nil
                
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
        PreferencesGeneral.shared.hapticFeedback = true
        
        // Setting - Security
        PreferencesSecurity.shared.isBiometricEnabled = false
        PreferencesSecurity.shared.isSecurityReinforced = false
        
        // Setting - Display
        PreferencesDisplayHome.shared.subscription_isDisplayed = true
        PreferencesDisplayHome.shared.subscription_value = 2
        
        PreferencesDisplayHome.shared.savingsPlan_isDisplayed = true
        PreferencesDisplayHome.shared.savingsPlan_value = 4
        
        PreferencesDisplayHome.shared.transaction_isDisplayed = true
        PreferencesDisplayHome.shared.transaction_value = 6
        
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
