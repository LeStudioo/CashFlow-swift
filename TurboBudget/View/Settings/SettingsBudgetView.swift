//
//  SettingsBudgetView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI

struct SettingsBudgetView: View {
    
    // Preferences
    @Preference(\.blockExpensesIfBudgetAmountExceeds) var blockExpensesIfBudgetAmountExceeds
    @Preference(\.budgetPercentage) var budgetPercentage
    
    // Number variables
    let percentages: [Double] = [50, 55, 60, 65, 70, 75, 80, 85, 90, 95]
    
    // MARK: - body
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $blockExpensesIfBudgetAmountExceeds) {
                    Text("setting_budgets_exceeded".localized)
                }
            } footer: {
                Text("setting_budgets_exceeded_desc".localized)
            }
            
            Section {
                Picker("setting_budgets_percentage".localized, selection: $budgetPercentage) {
                    ForEach(percentages, id: \.self) { num in
                        Text(Int(num).formatted() + "%").tag(num)
                    }
                }
            } footer: {
                Text("setting_budgets_percentage_alert".localized)
            }
        }
        .navigationTitle("word_budgets".localized)
        .navigationBarTitleDisplayMode(.inline)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SettingsBudgetView()
}
