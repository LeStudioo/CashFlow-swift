//
//  SettingsSectionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/05/2025.
//

import Foundation

struct SettingsSectionModel: Identifiable {
    let id: UUID = UUID()
    let title: String
    let items: [SettingItemModel]
}
    
extension SettingsSectionModel {
    static let general: SettingsSectionModel = .init(
        title: "title_setting_general".localized,
        items: [.general, .security]
    )
    
    static let display: SettingsSectionModel = .init(
        title: "setting_display_title".localized,
        items: [.appearance, .display]
    )
    
    static let features: SettingsSectionModel = .init(
        title: "settings_features_title".localized,
        items: [.account, .subscription, .applePay]
    )
    
    static let help: SettingsSectionModel = .init(
        title: "settings_help_title".localized,
        items: [.shortcutApplePay, .faq]
    )
    
    static let others: SettingsSectionModel = .init(
        title: "settings_others_title".localized,
        items: [.writeReview, .reportBug, .suggestFeature, .shareApp, .credits, .moreOfThisDeveloper]
    )
    
    static let manageAccount: SettingsSectionModel = .init(
        title: "settings_manage_accounts_title".localized,
        items: [.logout, .deleteAccount]
    )
    
    static let privacy: SettingsSectionModel = .init(
        title: "settings_privacy_title".localized,
        items: [.conditionsOfUse, .confidentialityPolicy]
    )
    
    static let all: [SettingsSectionModel] = [
        .general,
        .display,
        .features,
        .help,
        .others,
        .manageAccount,
        .privacy
    ]
        
}
