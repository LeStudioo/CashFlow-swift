//
//  PreferencesApplePay.swift
//  CashFlow
//
//  Created by Theo Sementa on 19/04/2025.
//

import Foundation
import Combine
import StatsKit
import CoreModule

public final class PreferencesApplePay: ObservableObject {
    public static let shared = PreferencesApplePay()
    
    public let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("PreferencesApplePay_isAddCategoryAutomaticallyEnabled", defaultValue: false)
    public var isAddCategoryAutomaticallyEnabled: Bool {
        willSet {
            if newValue { EventService.sendEvent(key: EventKeys.preferenceApplePayAutocat) }
            objectWillChange.send()
        }
    }
    
    @UserDefault("PreferencesApplePay_isAddAddressAutomaticallyEnabled", defaultValue: false)
    public var isAddAddressAutomaticallyEnabled: Bool {
        willSet {
            if newValue { EventService.sendEvent(key: EventKeys.preferenceApplePayPosition) }
            objectWillChange.send()
        }
    }
    
}
