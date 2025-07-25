//
//  UserDefaultWrapper.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

//import Foundation
//import Combine
//
//// static let appGroup = Preferences(userDefaults: .init(suiteName: "group.sementa.cashflow")!)
//
//@propertyWrapper
//struct UserDefault<T> {
//    let key: String
//    let defaultValue: T
//    
//    init(_ key: String, defaultValue: T) {
//        self.key = key
//        self.defaultValue = defaultValue
//    }
//    
//    var wrappedValue: T {
//        get { return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
//        set { UserDefaults.standard.set(newValue, forKey: key) }
//    }
//}
