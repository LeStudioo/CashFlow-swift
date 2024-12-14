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
    
    // MARK: -
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $preferencesSecurity.isBiometricEnabled) {
                    Text(Word.Classic.enable + " " + UIDevice.biometry.name)
                }
            } footer: {
                Text([Word.Classic.add, UIDevice.biometry.name, Word.Setting.Security.description].joined(separator: " "))
            }

            Section {
                Toggle(isOn: $preferencesSecurity.isSecurityReinforced) {
                    Text(Word.Setting.Security.securityPlus)
                }
            } footer: {
                Text(Word.Setting.Security.securityPlusDescription)
            }
        }
        .navigationTitle(Word.Title.Setting.security)
        .navigationBarTitleDisplayMode(.inline)
    } // body
} // struct

// MARK: - Preview
#Preview {
    NavigationStack {
        SettingsSecurityView()
    }
}
