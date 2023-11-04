//
//  SettingGeneralView.swift
//  CashFlow
//
//  Created by KaayZenn on 12/08/2023.
//
// Localizations 01/10/2023

import Foundation
import SwiftUI
import Setting

func settingGeneralView() -> SettingPage {
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    return SettingPage(title: NSLocalizedString("setting_general_title", comment: "")) {
        SettingGroup {
            SettingToggle(title: NSLocalizedString("setting_general_haptic_feedback", comment: ""), isOn: $userDefaultsManager.hapticFeedback)
        }
    }
    .previewIcon("gearshape.fill", foregroundColor: .white, backgroundColor: .gray)
}
