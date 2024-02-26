//
//  SettingsAccountView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI

struct SettingsAccountView: View {
    
    // Preferences
    @Preference(\.accountCanBeNegative) var accountCanBeNegative
    @Preference(\.blockExpensesIfCardLimitExceeds) var blockExpensesIfCardLimitExceeds
    @Preference(\.cardLimitPercentage) var cardLimitPercentage
    
    // Number variables
    let percentages: [Double] = [50, 55, 60, 65, 70, 75, 80, 85, 90, 95]
    
    // MARK: - body
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $accountCanBeNegative) {
                    Text("setting_account_negative".localized)
                }
            } footer: {
                Text("setting_account_negative_desc".localized)
            }

            Section {
                Toggle(isOn: $blockExpensesIfCardLimitExceeds) {
                    Text("setting_account_card_limit_exceeds".localized)
                }
            } footer: {
                Text("setting_account_card_limit_exceeds_desc".localized)
            }
            
            Section {
                Picker("setting_account_percentage_alert".localized, selection: $cardLimitPercentage) {
                    ForEach(percentages, id: \.self) { num in
                        Text(Int(num).formatted() + "%").tag(num)
                    }
                }
            } footer: {
                Text("setting_account_percentage_alert_desc".localized)
            }

        }
        .navigationTitle("word_account".localized)
        .navigationBarTitleDisplayMode(.inline)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SettingsAccountView()
}
