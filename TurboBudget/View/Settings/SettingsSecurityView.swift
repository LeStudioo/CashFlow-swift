//
//  SettingsSecurityView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI
import LocalAuthentication

struct SettingsSecurityView: View {
    
    // Preferences
    @StateObject private var preferencesSecurity: PreferencesSecurity = .shared
    
    // MARK: - body
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $preferencesSecurity.isBiometricEnabled) {
                    Text("word_enable".localized + " " + stringBiometric())
                }
            } footer: {
                Text("word_add".localized + " " + stringBiometric() + " " + "setting_security_desc".localized)
            }

            Section {
                Toggle(isOn: $preferencesSecurity.isSecurityReinforced) {
                    Text("setting_security_plus".localized)
                }
            } footer: {
                Text("setting_security_plus_desc".localized)
            }
        }
        .navigationTitle("setting_security_title".localized)
        .navigationBarTitleDisplayMode(.inline)
    } // End body
    
    // MARK: - Functions
    func stringBiometric() -> String {
        switch(biometricType()) {
        case .none: return "fail"
        case .touch: return "TouchID"
        case .face: return "FaceID"
        }
    }

} // End struct

// MARK: - Preview
#Preview {
    SettingsSecurityView()
}
