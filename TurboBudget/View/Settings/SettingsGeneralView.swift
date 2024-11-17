//
//  SettingsGeneralView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI

struct SettingsGeneralView: View {
    
    // Preferences
    @StateObject private var preferencesGeneral: PreferencesGeneral = .shared
    
    // MARK: - body
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $preferencesGeneral.hapticFeedback) {
                    Text("setting_general_haptic_feedback".localized)
                }
            }
        }
        .navigationTitle("setting_general_title".localized)
        .navigationBarTitleDisplayMode(.inline)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SettingsGeneralView()
}
