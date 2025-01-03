//
//  PreferencesSecurity.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

import Foundation

final class PreferencesSecurity: ObservableObject {
    static let shared = PreferencesSecurity()
        
    @CustomUserDefault("isFaceIDEnabled", defaultValue: false) // PreferencesSecurity_isBiometricEnabled
    var isBiometricEnabled: Bool
    
    @CustomUserDefault("isSecurityPlusEnabled", defaultValue: false) // PreferencesSecurity_isSecurityReinforced
    var isSecurityReinforced: Bool
    
}
