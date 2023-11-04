//
//  SettingSavingPlansView.swift
//  CashFlow
//
//  Created by KaayZenn on 13/08/2023.
//
// Localizations 01/10/2023

import Foundation
import SwiftUI
import Setting

func settingSavingPlansView(indexDayArchived: Binding<Int>) -> SettingPage {
    
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    @State var arrayOfDayArchived: [String] = ["0", "1", "2", "3", "5", "10", "30"]
    
    return SettingPage(title: NSLocalizedString("word_savingsplans", comment: "")) {
        SettingGroup(footer: userDefaultsManager.automatedArchivedSavingPlan ? NSLocalizedString("setting_savingsplans_nbr_days_archiving_desc", comment: "") : "") {
            
            SettingToggle(title: NSLocalizedString("setting_savingsplans_automatic_archiving", comment: ""), isOn: $userDefaultsManager.automatedArchivedSavingPlan)
            
            if userDefaultsManager.automatedArchivedSavingPlan {
                SettingPicker(title: NSLocalizedString("setting_savingsplans_nbr_days", comment: ""), choices: arrayOfDayArchived, selectedIndex: indexDayArchived)
                    .pickerDisplayMode(.menu)
            }
        }
    }
    .previewIcon("building.columns.fill", foregroundColor: .white, backgroundColor: .pink)
}
