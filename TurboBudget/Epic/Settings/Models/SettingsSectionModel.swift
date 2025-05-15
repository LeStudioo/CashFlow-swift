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
        title: "General", // TODO: TBL
        items: [.general, .security]
    )
    
    static let display: SettingsSectionModel = .init(
        title: "Display", // TODO: TBL
        items: [.appearance, .display]
    )
    
    static let features: SettingsSectionModel = .init(
        title: "Features", // TODO: TBL
        items: [.account, .subscription, .applePay]
    )
    
    static let help: SettingsSectionModel = .init(
        title: "Help", // TODO: TBL
        items: [.shortcutApplePay, .faq]
    )
    
    static let others: SettingsSectionModel = .init(
        title: "Others", // TODO: TBL
        items: [.writeReview, .reportBug, .suggestFeature, .shareApp, .credits, .moreOfThisDeveloper]
    )
    
    static let manageAccount: SettingsSectionModel = .init(
        title: "Manage Accounts", // TODO: TBL
        items: [.logout, .deleteAccount]
    )
    
    static let privacy: SettingsSectionModel = .init(
        title: "Privacy", // TODO: TBL
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
