//
//  PreferencesSecurity.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

import Foundation
import Combine

final class PreferencesSecurity: ObservableObject {
    static let shared = PreferencesSecurity()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @CustomUserDefault("isFaceIDEnabled", defaultValue: false) // PreferencesSecurity_isBiometricEnabled
    var isBiometricEnabled: Bool {
        willSet { objectWillChange.send() }
    }
    
    @CustomUserDefault("isSecurityPlusEnabled", defaultValue: false) // PreferencesSecurity_isSecurityReinforced
    var isSecurityReinforced: Bool {
        willSet { objectWillChange.send() }
    }
    
}
