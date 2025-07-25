//
//  PreferencesSecurity.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

import Foundation
import Combine
import StatsKit
import CoreModule
import PreferencesModule

final class PreferencesSecurity: ObservableObject {
    static let shared = PreferencesSecurity()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
        
    @UserDefault("isFaceIDEnabled", defaultValue: false) // PreferencesSecurity_isBiometricEnabled
    var isBiometricEnabled: Bool {
        willSet {
            if newValue { EventService.sendEvent(key: EventKeys.preferenceSecurityBiometrie) }
            objectWillChange.send() }
    }
    
    @UserDefault("isSecurityPlusEnabled", defaultValue: false) // PreferencesSecurity_isSecurityReinforced
    var isSecurityReinforced: Bool {
        willSet {
            if newValue { EventService.sendEvent(key: EventKeys.preferenceSecurityReinforced) }
            objectWillChange.send()
        }
    }
    
}
