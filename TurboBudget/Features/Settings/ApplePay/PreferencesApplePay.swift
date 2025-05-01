//
//  PreferencesApplePay.swift
//  CashFlow
//
//  Created by Theo Sementa on 19/04/2025.
//

import Foundation
import Combine
import StatsKit

final class PreferencesApplePay: ObservableObject {
    static let shared = PreferencesApplePay()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault(UserDefaultsKeys.Preferences.ApplePay.isAddCategoryAutomaticallyEnabled, defaultValue: false)
    var isAddCategoryAutomaticallyEnabled: Bool {
        willSet {
            if newValue { EventService.sendEvent(key: .preferenceApplePayAutocat) }
            objectWillChange.send()
        }
    }
    
    @UserDefault(UserDefaultsKeys.Preferences.ApplePay.isAddAddressAutomaticallyEnabled, defaultValue: false)
    var isAddAddressAutomaticallyEnabled: Bool {
        willSet {
            if newValue { EventService.sendEvent(key: .preferenceApplePayPosition) }
            objectWillChange.send()
        }
    }
    
}
