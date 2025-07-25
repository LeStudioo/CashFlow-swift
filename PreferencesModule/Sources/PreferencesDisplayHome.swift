//
//  PreferencesDisplayHome.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

import Foundation
import Combine

public final class PreferencesDisplayHome: ObservableObject {
    public static let shared = PreferencesDisplayHome()
    
    public let objectWillChange = PassthroughSubject<Void, Never>()
        
    @UserDefault("isSavingPlansDisplayedHomeScreen", defaultValue: true) // PreferencesDisplayHome_savingsPlan_isDisplayed
    public var savingsPlan_isDisplayed: Bool {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault("numberOfSavingPlansDisplayedInHomeScreen", defaultValue: 4) // PreferencesDisplayHome_savingsPlan_value
    public var savingsPlan_value: Int {
        willSet { objectWillChange.send() }
    }

    @UserDefault("isAutomationsDisplayedHomeScreen", defaultValue: true) // PreferencesDisplayHome_subscription_isDisplayed
    public var subscription_isDisplayed: Bool {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault("numberOfAutomationsDisplayedInHomeScreen", defaultValue: 4) // PreferencesDisplayHome_subscription_value
    public var subscription_value: Int {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault("isRecentTransactionsDisplayedHomeScreen", defaultValue: true) // PreferencesDisplayHome_transaction_isDisplayed
    public var transaction_isDisplayed: Bool {
        willSet { objectWillChange.send() }
    }

    @UserDefault("numberOfRecentTransactionDisplayedInHomeScreen", defaultValue: 5) // PreferencesDisplayHome_transaction_value
    public var transaction_value: Int {
        willSet { objectWillChange.send() }
    }
}
