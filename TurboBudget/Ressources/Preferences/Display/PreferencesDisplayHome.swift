//
//  PreferencesDisplayHome.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

import Foundation
import Combine

final class PreferencesDisplayHome: ObservableObject {
    static let shared = PreferencesDisplayHome()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @CustomUserDefault("isSavingPlansDisplayedHomeScreen", defaultValue: true) // PreferencesDisplayHome_savingsPlan_isDisplayed
    var savingsPlan_isDisplayed: Bool {
        willSet { objectWillChange.send() }
    }
    
    @CustomUserDefault("numberOfSavingPlansDisplayedInHomeScreen", defaultValue: 4) // PreferencesDisplayHome_savingsPlan_value
    var savingsPlan_value: Int {
        willSet { objectWillChange.send() }
    }


    @CustomUserDefault("isAutomationsDisplayedHomeScreen", defaultValue: true) // PreferencesDisplayHome_subscription_isDisplayed
    var subscription_isDisplayed: Bool {
        willSet { objectWillChange.send() }
    }
    
    @CustomUserDefault("numberOfAutomationsDisplayedInHomeScreen", defaultValue: 4) // PreferencesDisplayHome_subscription_value
    var subscription_value: Int {
        willSet { objectWillChange.send() }
    }
    
    
    @CustomUserDefault("isRecentTransactionsDisplayedHomeScreen", defaultValue: true) // PreferencesDisplayHome_transaction_isDisplayed
    var transaction_isDisplayed: Bool {
        willSet { objectWillChange.send() }
    }

    @CustomUserDefault("numberOfRecentTransactionDisplayedInHomeScreen", defaultValue: 5) // PreferencesDisplayHome_transaction_value
    var transaction_value: Int {
        willSet { objectWillChange.send() }
    }
}
