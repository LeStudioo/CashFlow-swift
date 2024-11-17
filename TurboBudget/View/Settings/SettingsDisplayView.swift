//
//  SettingsDisplayView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI

struct SettingsDisplayView: View {
    
    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared
    
    // Number variables
    let automationsNumber: [Int] = [2, 4, 6]
    let savingPlansNumber: [Int] = [2, 4, 6]
    let recentTransactionsNumber: [Int] = [5, 6, 7, 8, 9, 10]
    
    // MARK: -
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $preferencesDisplayHome.subscription_isDisplayed, label: {
                    Text("word_automations".localized)
                })
                if preferencesDisplayHome.subscription_isDisplayed {
                    Picker("setting_display_nbr_automations".localized, selection: $preferencesDisplayHome.subscription_value) {
                        ForEach(automationsNumber, id: \.self) { num in
                            Text(num.formatted()).tag(num)
                        }
                    }
                }
            } header: {
                Text("setting_display_displayed_home_screen".localized)
            }
            
            Section {
                Toggle(isOn: $preferencesDisplayHome.savingsPlan_isDisplayed, label: {
                    Text("word_savingsplans".localized)
                })
                if preferencesDisplayHome.savingsPlan_isDisplayed {
                    Picker("setting_display_nbr_savingsplans".localized, selection: $preferencesDisplayHome.savingsPlan_value) {
                        ForEach(savingPlansNumber, id: \.self) { num in
                            Text(num.formatted()).tag(num)
                        }
                    }
                }
            }
            
            Section {
                Toggle(isOn: $preferencesDisplayHome.transaction_isDisplayed, label: {
                    Text("setting_display_recent_transactions".localized)
                })
                if preferencesDisplayHome.transaction_isDisplayed {
                    Picker("setting_display_nbr_transactions".localized, selection: $preferencesDisplayHome.transaction_value) {
                        ForEach(recentTransactionsNumber, id: \.self) { num in
                            Text(num.formatted()).tag(num)
                        }
                    }
                }
            }
        }
        .navigationTitle("setting_display_title".localized)
        .navigationBarTitleDisplayMode(.inline)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SettingsDisplayView()
}
