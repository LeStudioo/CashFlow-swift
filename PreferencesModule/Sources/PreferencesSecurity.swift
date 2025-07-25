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

public final class PreferencesSecurity: ObservableObject {
    public static let shared = PreferencesSecurity()
    
    public let objectWillChange = PassthroughSubject<Void, Never>()
        
    @UserDefault("isFaceIDEnabled", defaultValue: false) // PreferencesSecurity_isBiometricEnabled
    public var isBiometricEnabled: Bool {
        willSet {
            if newValue { EventService.sendEvent(key: EventKeys.preferenceSecurityBiometrie) }
            objectWillChange.send() }
    }
    
    @UserDefault("isSecurityPlusEnabled", defaultValue: false) // PreferencesSecurity_isSecurityReinforced
    public var isSecurityReinforced: Bool {
        willSet {
            if newValue { EventService.sendEvent(key: EventKeys.preferenceSecurityReinforced) }
            objectWillChange.send()
        }
    }
    
}
