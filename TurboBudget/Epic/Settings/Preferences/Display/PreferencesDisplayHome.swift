//
//  PreferencesDisplayHome.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

import Foundation
import Combine
import PreferencesModule

final class PreferencesDisplayHome: ObservableObject {
    static let shared = PreferencesDisplayHome()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
        
    @UserDefault("isSavingPlansDisplayedHomeScreen", defaultValue: true) // PreferencesDisplayHome_savingsPlan_isDisplayed
    var savingsPlan_isDisplayed: Bool {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault("numberOfSavingPlansDisplayedInHomeScreen", defaultValue: 4) // PreferencesDisplayHome_savingsPlan_value
    var savingsPlan_value: Int {
        willSet { objectWillChange.send() }
    }

    @UserDefault("isAutomationsDisplayedHomeScreen", defaultValue: true) // PreferencesDisplayHome_subscription_isDisplayed
    var subscription_isDisplayed: Bool {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault("numberOfAutomationsDisplayedInHomeScreen", defaultValue: 4) // PreferencesDisplayHome_subscription_value
    var subscription_value: Int {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault("isRecentTransactionsDisplayedHomeScreen", defaultValue: true) // PreferencesDisplayHome_transaction_isDisplayed
    var transaction_isDisplayed: Bool {
        willSet { objectWillChange.send() }
    }

    @UserDefault("numberOfRecentTransactionDisplayedInHomeScreen", defaultValue: 5) // PreferencesDisplayHome_transaction_value
    var transaction_value: Int {
        willSet { objectWillChange.send() }
    }
}
