//
//  SettingSecurityView.swift
//  CashFlow
//
//  Created by KaayZenn on 13/08/2023.
//
// Localizations 01/10/2023

import Foundation
import SwiftUI
import Setting

func stringBiometric() -> String {
    switch(biometricType()) {
    case .none: return "fail"
    case .touch: return "TouchID"
    case .face: return "FaceID"
    }
}

func settingSecurityView() -> SettingPage {
    
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    return SettingPage(title: NSLocalizedString("setting_security_title", comment: "")) {
        SettingGroup(footer: NSLocalizedString("word_add", comment: "") + " " + stringBiometric() + " " + NSLocalizedString("setting_security_desc", comment: "")) {
            SettingToggle(title: NSLocalizedString("word_enable", comment: "") + " " + stringBiometric(), isOn: $userDefaultsManager.isFaceIDEnable)
        }
        
        SettingGroup(footer: NSLocalizedString("setting_security_plus_desc", comment: "")) {
            SettingToggle(title: NSLocalizedString("setting_security_plus", comment: ""), isOn: $userDefaultsManager.isSecurityPlusEnable)
        }
    }
    .previewIcon("lock.fill", foregroundColor: .white, backgroundColor: .green)
}
