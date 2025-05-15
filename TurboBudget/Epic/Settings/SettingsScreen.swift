//
//  SettingsScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/05/2025.
//

import SwiftUI
import AlertKit
import TheoKit

struct SettingsScreen: View {
    
    // MARK: Environment
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject var store: PurchasesManager
    @Environment(\.dismiss) private var dismiss
    
    // Boolean variables
    @State private var isSharing: Bool = false
    @State private var searchText: String = ""
    
    var settingsFiltered: [SettingsSectionModel] {
        if searchText.isEmpty {
            return SettingsSectionModel.all
        } else {
            return SettingsSectionModel.all.filter { section in
                section.items.contains { item in
                    item.title.localizedStandardContains(searchText)
                }
            }
        }
    }
    
    // MARK: - View
    var body: some View {
        ListWithBluredHeader(maxBlurRadius: DesignSystem.Blur.topbar) {
            NavigationBar(
                title: "setting_home_title".localized,
                placeholder: "word_search".localized,
                searchText: $searchText
            )
        } content: {
            SettingsRowView(item: .cashFlowPro)
                .noDefaultStyle()
                .padding(.bottom, TKDesignSystem.Spacing.extraLarge)
                .padding(.horizontal, TKDesignSystem.Padding.large)
            
            ForEach(settingsFiltered) { section in
                VStack(spacing: TKDesignSystem.Spacing.standard) {
                    Text(section.title)
                        .fontWithLineHeight(DesignSystem.Fonts.Title.medium)
                        .foregroundStyle(Color.label)
                        .fullWidth(.leading)
                        
                    VStack(spacing: TKDesignSystem.Spacing.medium) {
                        let filteredItems = section.items.filter { item in
                            item.title.localizedStandardContains(searchText)
                        }
                        ForEach(searchText.isEmpty ? section.items : filteredItems) { item in
                            SettingsRowView(item: item)
                        }
                    }
                }
                .padding(.bottom, TKDesignSystem.Spacing.extraLarge)
            }
            .noDefaultStyle()
            .padding(.horizontal, TKDesignSystem.Padding.large)
        }
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    SettingsScreen()
}
