//
//  SettingsApplePayView.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/12/2024.
//

import SwiftUI

struct SettingsApplePayView: View {
        
    @State private var isAddCategoryAutomaticallyEnabled: Bool = false
    @State private var isAddAddressAutomaticallyEnabled: Bool = false
    
    // MARK: -
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $isAddCategoryAutomaticallyEnabled) {
                    Text(Word.Setting.ApplePay.addCategory)
                }
            } footer: {
                Text(Word.Setting.ApplePay.footer)
            }
            
            Section {
                Toggle(isOn: $isAddAddressAutomaticallyEnabled) {
                    Text("settings_preferences_applepay_address".localized)
                }
            } footer: {
                Text("settings_preferences_applepay_address_footer".localized)
            }
            .onChange(of: isAddAddressAutomaticallyEnabled) { newValue in
                if newValue { LocationManager.shared.requestLocationPermission() }
            }
        }
        .navigationTitle("Apple Pay")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isAddCategoryAutomaticallyEnabled = UserDefaultsManager.shared.get(
                Bool.self,
                forKey: UserDefaultsKeys.Preferences.ApplePay.isAddCategoryAutomaticallyEnabled
            ) ?? false
            
            isAddAddressAutomaticallyEnabled = UserDefaultsManager.shared.get(
                Bool.self,
                forKey: UserDefaultsKeys.Preferences.ApplePay.isAddAddressAutomaticallyEnabled
            ) ?? false
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SettingsApplePayView()
}
