//
//  UserDefault.swift
//  CoreModule
//
//  Created by Theo Sementa on 25/07/2025.
//

import Foundation
import Combine

// static let appGroup = Preferences(userDefaults: .init(suiteName: "group.sementa.cashflow")!)

@propertyWrapper
public struct UserDefault<T> {
    public let key: String
    public let defaultValue: T
    
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get { return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}
