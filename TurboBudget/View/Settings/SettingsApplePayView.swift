//
//  SettingsApplePayView.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/12/2024.
//

import SwiftUI

struct SettingsApplePayView: View {
    
    @StateObject private var preferencesApplePay: PreferencesApplePay = .shared
    
    // MARK: -
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $preferencesApplePay.isAddCategoryAutomaticallyEnabled) {
                    Text(Word.Setting.ApplePay.addCategory)
                }
            } footer: {
                Text(Word.Setting.ApplePay.footer)
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
