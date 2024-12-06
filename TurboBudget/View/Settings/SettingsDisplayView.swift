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
                Toggle(isOn: $preferencesDisplayHome.subscription_isDisplayed) {
                    Text(Word.Main.subscription)
                }
                Picker(Word.Setting.Display.nbrSubscriptions, selection: $preferencesDisplayHome.subscription_value) {
                    ForEach(automationsNumber, id: \.self) { num in
                        Text(num.formatted()).tag(num)
                    }
                }
                .isDisplayed(preferencesDisplayHome.subscription_isDisplayed)
            } header: {
                Text(Word.Setting.Display.homeScreen)
            }
            
            Section {
                Toggle(isOn: $preferencesDisplayHome.savingsPlan_isDisplayed) {
                    Text(Word.Main.savingsPlan)
                }
                Picker(Word.Setting.Display.nbrSavingsPlans, selection: $preferencesDisplayHome.savingsPlan_value) {
                    ForEach(savingPlansNumber, id: \.self) { num in
                        Text(num.formatted()).tag(num)
                    }
                }
                .isDisplayed(preferencesDisplayHome.savingsPlan_isDisplayed)
            }
            
            Section {
                Toggle(isOn: $preferencesDisplayHome.transaction_isDisplayed) {
                    Text(Word.Main.transaction)
                }
                Picker(Word.Setting.Display.nbrTransactions, selection: $preferencesDisplayHome.transaction_value) {
                    ForEach(recentTransactionsNumber, id: \.self) { num in
                        Text(num.formatted()).tag(num)
                    }
                }
                .isDisplayed(preferencesDisplayHome.transaction_isDisplayed)
            }
        }
        .navigationTitle(Word.Title.Setting.display)
        .navigationBarTitleDisplayMode(.inline)
    } // body
} // struct

// MARK: - Preview
#Preview {
    NavigationStack {
        SettingsDisplayView()
    }
}
