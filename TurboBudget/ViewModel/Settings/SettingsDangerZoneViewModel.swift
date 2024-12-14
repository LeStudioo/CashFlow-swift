//
//  SettingsDangerZoneViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import Foundation

final class SettingsDangerZoneViewModel: ObservableObject {
                    
}

extension SettingsDangerZoneViewModel {
    
    func resetSettings() {
        
        // Setting - General
        PreferencesGeneral.shared.hapticFeedback = true
        
        // Setting - Security
        PreferencesSecurity.shared.isBiometricEnabled = false
        PreferencesSecurity.shared.isSecurityReinforced = false
        
        // Setting - Display
        PreferencesDisplayHome.shared.subscription_isDisplayed = true
        PreferencesDisplayHome.shared.subscription_value = 2
        
        PreferencesDisplayHome.shared.savingsPlan_isDisplayed = true
        PreferencesDisplayHome.shared.savingsPlan_value = 4
        
        PreferencesDisplayHome.shared.transaction_isDisplayed = true
        PreferencesDisplayHome.shared.transaction_value = 6
        
        // Setting - Appearance
        ThemeManager.shared.theme = .green
        
    }
    
}
