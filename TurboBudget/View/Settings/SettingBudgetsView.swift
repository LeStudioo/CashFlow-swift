//
//  SettingBudgetsView.swift
//  CashFlow
//
//  Created by KaayZenn on 13/08/2023.
//
// Localizations 01/10/2023

import Foundation
import SwiftUI
import Setting

func settingBudgetsView(indexChoosePercentage: Binding<Int>) -> SettingPage {
    
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    @State var percentages: [String] = ["50%", "55%", "60%", "65%", "70%", "75%", "80%", "85%", "90%", "95%"]
    
    return SettingPage(title: NSLocalizedString("word_budgets", comment: "")) {
        SettingGroup(footer: NSLocalizedString("setting_budgets_exceeded_desc", comment: "")) {
            SettingToggle(title: NSLocalizedString("setting_budgets_exceeded", comment: ""), isOn: $userDefaultsManager.blockExpensesIfBudgetAmountExceeds)
        }
        
        SettingGroup(footer: NSLocalizedString("setting_budgets_percentage_alert", comment: "")) {
            SettingPicker(title: NSLocalizedString("setting_budgets_percentage", comment: ""), choices: percentages, selectedIndex: indexChoosePercentage)
                .pickerDisplayMode(.menu)
        }
    }
    .previewIcon("chart.pie.fill", foregroundColor: .white, backgroundColor: .purple)
}

