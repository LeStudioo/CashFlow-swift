//
//  Preferences.swift
//  CashFlow
//
//  Created by KaayZenn on 15/02/2024.
// https://www.avanderlee.com/swift/appstorage-explained/

import Foundation
import Combine
import SwiftUI

final class Preferences {

    static let standard = Preferences(userDefaults: .standard)
    static let appGroup = Preferences(userDefaults: .init(suiteName: "group.sementa.cashflow")!)
    fileprivate let userDefaults: UserDefaults

    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    // MARK: AppGroup
   
        
    // MARK: Normal
    @UserDefault("colorSelected")
    var colorSelected: String = "green"

    @UserDefault("alreadyOpen")
    var alreadyOpen: Bool = false
    
    // Setting - General
    @UserDefault("hapticFeedback")
    var hapticFeedback: Bool = true
    
    
    // Setting - Security
    @UserDefault("isFaceIDEnabled")
    var isFaceIDEnabled: Bool = false
    
    @UserDefault("isSecurityPlusEnabled")
    var isSecurityPlusEnabled: Bool = false
    
    
    // Setting - Display - Home Screen
    @UserDefault("isSavingPlansDisplayedHomeScreen")
    var isSavingPlansDisplayedHomeScreen: Bool = true
    
    @UserDefault("numberOfSavingPlansDisplayedInHomeScreen")
    var numberOfSavingPlansDisplayedInHomeScreen: Int = 4

    @UserDefault("isAutomationsDisplayedHomeScreen")
    var isAutomationsDisplayedHomeScreen: Bool = true
    
    @UserDefault("numberOfAutomationsDisplayedInHomeScreen")
    var numberOfAutomationsDisplayedInHomeScreen: Int = 4
    
    @UserDefault("isRecentTransactionsDisplayedHomeScreen")
    var isRecentTransactionsDisplayedHomeScreen: Bool = true
    
    @UserDefault("numberOfRecentTransactionDisplayedInHomeScreen") // PREVIOUS = recentTransactionNumber
    var numberOfRecentTransactionDisplayedInHomeScreen: Int = 5
    

    //Setting - Account
    @UserDefault("accountCanBeNegative")
    var accountCanBeNegative: Bool = false
    
    @UserDefault("blockExpensesIfCardLimitExceeds")
    var blockExpensesIfCardLimitExceeds: Bool = true

    @UserDefault("cardLimitPercentage")
    var cardLimitPercentage: Double = 80

    
    // Setting - Saving Plan
    @UserDefault("automatedArchivedSavingPlan")
    var automatedArchivedSavingPlan: Bool = false
    
    @UserDefault("numberOfDayForArchivedSavingPlan")
    var numberOfDayForArchivedSavingPlan: Int = 30
    
    
    //Setting - Budgets
    @UserDefault("blockExpensesIfBudgetAmountExceeds")
    var blockExpensesIfBudgetAmountExceeds: Bool = true
    
    @UserDefault("budgetPercentage")
    var budgetPercentage: Double = 80
    
    
    //Setting - Financial Advice
    @UserDefault("isStepsEnbaledForAllSavingsPlans") //FA4
    var isStepsEnbaledForAllSavingsPlans: Bool = false
    
    @UserDefault("isNoSpendChallengeEnbaled") //FA5
    var isNoSpendChallengeEnbaled: Bool = false

    @UserDefault("isBuyingQualityEnabled") //FA6
    var isBuyingQualityEnabled: Bool = false
    
    @UserDefault("isPayingYourselfFirstEnabled") //FA7
    var isPayingYourselfFirstEnabled: Bool = false
    
    @UserDefault("isSearchDuplicateEnabled") //FA9
    var isSearchDuplicateEnabled: Bool = false
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value

    var wrappedValue: Value {
        get { fatalError("Wrapped value should not be used.") }
        set { fatalError("Wrapped value should not be used.") }
    }

    init(wrappedValue: Value, _ key: String) {
        self.defaultValue = wrappedValue
        self.key = key
    }

    public static subscript(
        _enclosingInstance instance: Preferences,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Preferences, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<Preferences, Self>
    ) -> Value {
        get {
            let container = instance.userDefaults
            let key = instance[keyPath: storageKeyPath].key
            let defaultValue = instance[keyPath: storageKeyPath].defaultValue
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            let container = instance.userDefaults
            let key = instance[keyPath: storageKeyPath].key
            container.set(newValue, forKey: key)
            instance.preferencesChangedSubject.send(wrappedKeyPath)
        }
    }
}

@propertyWrapper
struct Preference<Value>: DynamicProperty {

    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<Preferences, Value>
    private let preferences: Preferences

    init(_ keyPath: ReferenceWritableKeyPath<Preferences, Value>, preferences: Preferences = .standard) {
        self.keyPath = keyPath
        self.preferences = preferences
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }.map { _ in () }
            .eraseToAnyPublisher()
        self.preferencesObserver = .init(publisher: publisher)
    }

    var wrappedValue: Value {
        get { preferences[keyPath: keyPath] }
        nonmutating set { preferences[keyPath: keyPath] = newValue }
    }

    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

@propertyWrapper
struct PreferenceWithAppGroup<Value>: DynamicProperty {

    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<Preferences, Value>
    private let preferences: Preferences

    init(_ keyPath: ReferenceWritableKeyPath<Preferences, Value>, preferences: Preferences = .appGroup) {
        self.keyPath = keyPath
        self.preferences = preferences
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }.map { _ in () }
            .eraseToAnyPublisher()
        self.preferencesObserver = .init(publisher: publisher)
    }

    var wrappedValue: Value {
        get { preferences[keyPath: keyPath] }
        nonmutating set { preferences[keyPath: keyPath] = newValue }
    }

    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

final class PublisherObservableObject: ObservableObject {

    var subscriber: AnyCancellable?

    init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        })
    }
}
