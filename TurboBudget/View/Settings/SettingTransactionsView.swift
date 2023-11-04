//
//  SettingTransactionsView.swift
//  CashFlow
//
//  Created by KaayZenn on 13/08/2023.
//
// Localizations 01/10/2023

import Foundation
import SwiftUI
import Setting

func settingTransactionView(indexDayArchivedTransaction: Binding<Int>) -> SettingPage {
    
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    @State var arrayOfDayArchived: [String] = ["0", "1", "2", "3", "5", "10", "30"]
    
    return SettingPage(title: NSLocalizedString("word_transactions", comment: "")) {
        
//        SettingGroup(footer: userDefaultsManager.automatedArchivedTransaction ? NSLocalizedString("setting_transactions_auto_archiving_desc", comment: "") : "") {
//            
//            SettingToggle(title: NSLocalizedString("setting_transactions_auto_archiving", comment: ""), isOn: $userDefaultsManager.automatedArchivedTransaction)
//            
//            if userDefaultsManager.automatedArchivedTransaction {
//                SettingPicker(title: NSLocalizedString("setting_transactions_nbr_days", comment: ""), choices: arrayOfDayArchived, selectedIndex: indexDayArchivedTransaction)
//                    .pickerDisplayMode(.menu)
//            }
//        }
    }
    .previewIcon("banknote.fill", foregroundColor: .white, backgroundColor: .red)
}
