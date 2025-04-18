////
////  UserDefaultWrapper.swift
////  CashFlow
////
////  Created by Theo Sementa on 17/11/2024.
////
//
//import Foundation
//import Combine
//
//// static let appGroup = Preferences(userDefaults: .init(suiteName: "group.sementa.cashflow")!)

@propertyWrapper
class CustomUserDefault<T> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults
    private let publisher = PassthroughSubject<T, Never>()
    
    init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
        
        // Register for UserDefaults changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDefaultsDidChange),
            name: UserDefaults.didChangeNotification,
            object: userDefaults
        )
    }
    
    var wrappedValue: T {
        get { return userDefaults.object(forKey: key) as? T ?? defaultValue }
        set {
            userDefaults.set(newValue, forKey: key)
            publisher.send(newValue)
        }
    }
    
    var projectedValue: AnyPublisher<T, Never> {
        return publisher.eraseToAnyPublisher()
    }
    
    @objc private func userDefaultsDidChange() {
        // When UserDefaults change, publish the new value
        publisher.send(wrappedValue)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
import Foundation
import Combine
import SwiftUI

final class Preferences {

    static let standard = Preferences(userDefaults: .standard)
//    static let appGroup = Preferences(userDefaults: .init(suiteName: "group.sementa.cashflow")!)
    fileprivate let userDefaults: UserDefaults

    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value

    var wrappedValue: Value {
        get { fatalError("Wrapped value should not be used.") }
        set { fatalError("Wrapped value should not be used.") } // swiftlint:disable:this unused_setter_value
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

final class PublisherObservableObject: ObservableObject {

    var subscriber: AnyCancellable?

    init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        })
    }
}
