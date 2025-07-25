//
//  SettingsApplePayView.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/12/2024.
//

import SwiftUI
import CoreModule
import PreferencesModule

struct SettingsApplePayView: View {
        
    @StateObject private var preferences: PreferencesApplePay = .shared
    
    // MARK: -
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $preferences.isAddCategoryAutomaticallyEnabled) {
                    Text(Word.Setting.ApplePay.addCategory)
                }
            } footer: {
                Text(Word.Setting.ApplePay.footer)
            }
            
            Section {
                Toggle(isOn: $preferences.isAddAddressAutomaticallyEnabled) {
                    Text("settings_preferences_applepay_address".localized)
                }
            } footer: {
                Text("settings_preferences_applepay_address_footer".localized)
            }
            .onChange(of: preferences.isAddAddressAutomaticallyEnabled) { newValue in
                if newValue { LocationManager.shared.requestLocationPermission() }
            }
        }
        .navigationTitle("Apple Pay")
        .navigationBarTitleDisplayMode(.inline)
    } // body
} // struct

// MARK: - Preview
#Preview {
    SettingsApplePayView()
}
