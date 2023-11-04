//
//  SettingAccountView.swift
//  CashFlow
//
//  Created by KaayZenn on 13/08/2023.
//
// Localizations 01/10/2023

import Foundation
import SwiftUI
import Setting

func settingAccountView(indexChoosePercentage: Binding<Int>) -> SettingPage {
    
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    @State var percentages: [String] = ["50%", "55%", "60%", "65%", "70%", "75%", "80%", "85%", "90%", "95%"]
    
    return SettingPage(title: NSLocalizedString("word_account", comment: "")) {
        SettingGroup(footer: NSLocalizedString("setting_account_negative_desc", comment: "")) {
            SettingToggle(title: NSLocalizedString("setting_account_negative", comment: ""), isOn: $userDefaultsManager.accountCanBeNegative)
        }
        
        SettingGroup(footer: NSLocalizedString("setting_account_card_limit_exceeds_desc", comment: "")) {
            SettingToggle(title: NSLocalizedString("setting_account_card_limit_exceeds", comment: ""), isOn: $userDefaultsManager.blockExpensesIfCardLimitExceeds)
        }
        
        SettingGroup(footer: NSLocalizedString("setting_account_percentage_alert_desc", comment: "")) {
            SettingPicker(title: NSLocalizedString("setting_account_percentage_alert", comment: ""), choices: percentages, selectedIndex: indexChoosePercentage)
                .pickerDisplayMode(.menu)
        }
    }
    .previewIcon("person.fill", foregroundColor: .white, backgroundColor: .blue)
}
