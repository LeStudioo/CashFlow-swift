//
//  SettingsGeneralView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI
import CoreModule

struct SettingsGeneralView: View {
    
    // Preferences
    @StateObject private var preferencesGeneral: PreferencesGeneral = .shared
    
    // MARK: - body
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $preferencesGeneral.hapticFeedback) {
                    Text(Word.Setting.General.hapticFeedback)
                }
            }
        }
        .navigationTitle(Word.Title.Setting.general)
        .navigationBarTitleDisplayMode(.inline)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    NavigationStack {
        SettingsGeneralView()
    }
}
