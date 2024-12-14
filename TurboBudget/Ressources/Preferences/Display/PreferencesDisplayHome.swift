//
//  PreferencesDisplayHome.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

import Foundation

final class PreferencesDisplayHome: ObservableObject {
    static let shared = PreferencesDisplayHome()
        
    @CustomUserDefault("isSavingPlansDisplayedHomeScreen", defaultValue: true) // PreferencesDisplayHome_savingsPlan_isDisplayed
    var savingsPlan_isDisplayed: Bool
    
    @CustomUserDefault("numberOfSavingPlansDisplayedInHomeScreen", defaultValue: 4) // PreferencesDisplayHome_savingsPlan_value
    var savingsPlan_value: Int


    @CustomUserDefault("isAutomationsDisplayedHomeScreen", defaultValue: true) // PreferencesDisplayHome_subscription_isDisplayed
    var subscription_isDisplayed: Bool
    
    @CustomUserDefault("numberOfAutomationsDisplayedInHomeScreen", defaultValue: 4) // PreferencesDisplayHome_subscription_value
    var subscription_value: Int
    
    
    @CustomUserDefault("isRecentTransactionsDisplayedHomeScreen", defaultValue: true) // PreferencesDisplayHome_transaction_isDisplayed
    var transaction_isDisplayed: Bool

    @CustomUserDefault("numberOfRecentTransactionDisplayedInHomeScreen", defaultValue: 5) // PreferencesDisplayHome_transaction_value
    var transaction_value: Int
}
