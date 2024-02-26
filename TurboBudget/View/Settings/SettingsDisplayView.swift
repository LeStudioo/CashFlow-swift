//
//  SettingsDisplayView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI

struct SettingsDisplayView: View {
    
    // Preferences
    @Preference(\.isAutomationsDisplayedHomeScreen) var isAutomationsDisplayedHomeScreen
    @Preference(\.numberOfAutomationsDisplayedInHomeScreen) var numberOfAutomationsDisplayedInHomeScreen
    
    @Preference(\.isSavingPlansDisplayedHomeScreen) var isSavingPlansDisplayedHomeScreen
    @Preference(\.numberOfSavingPlansDisplayedInHomeScreen) var numberOfSavingPlansDisplayedInHomeScreen
    
    @Preference(\.isRecentTransactionsDisplayedHomeScreen) var isRecentTransactionsDisplayedHomeScreen
    @Preference(\.numberOfRecentTransactionDisplayedInHomeScreen) var numberOfRecentTransactionDisplayedInHomeScreen
    
    // Number variables
    let automationsNumber: [Int] = [2, 4, 6]
    let savingPlansNumber: [Int] = [2, 4, 6]
    let recentTransactionsNumber: [Int] = [5, 6, 7, 8, 9, 10]
    
    // MARK: - body
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $isAutomationsDisplayedHomeScreen, label: {
                    Text("word_automations".localized)
                })
                if isAutomationsDisplayedHomeScreen {
                    Picker("setting_display_nbr_automations".localized, selection: $numberOfAutomationsDisplayedInHomeScreen) {
                        ForEach(automationsNumber, id: \.self) { num in
                            Text(num.formatted()).tag(num)
                        }
                    }
                }
                
                Toggle(isOn: $isSavingPlansDisplayedHomeScreen, label: {
                    Text("word_savingsplans".localized)
                })
                if isSavingPlansDisplayedHomeScreen {
                    Picker("setting_display_nbr_savingsplans".localized, selection: $numberOfSavingPlansDisplayedInHomeScreen) {
                        ForEach(savingPlansNumber, id: \.self) { num in
                            Text(num.formatted()).tag(num)
                        }
                    }
                }
 
                Toggle(isOn: $isRecentTransactionsDisplayedHomeScreen, label: {
                    Text("setting_display_recent_transactions".localized)
                })
                if isRecentTransactionsDisplayedHomeScreen {
                    Picker("setting_display_nbr_transactions".localized, selection: $numberOfRecentTransactionDisplayedInHomeScreen) {
                        ForEach(recentTransactionsNumber, id: \.self) { num in
                            Text(num.formatted()).tag(num)
                        }
                    }
                }
            } header: {
                Text("setting_display_displayed_home_screen".localized)
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
