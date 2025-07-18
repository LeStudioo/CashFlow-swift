//
//  SettingsScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/05/2025.
//

import SwiftUI
import AlertKit
import TheoKit
import DesignSystemModule

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
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: "setting_home_title".localized,
                placeholder: "word_search".localized,
                searchText: $searchText
            )
        } content: { _ in
            SettingsRowView(item: .cashFlowPro)
                .padding(.bottom, Spacing.extraLarge)
                .padding(.horizontal, Padding.large)
            
            ForEach(settingsFiltered) { section in
                VStack(spacing: Spacing.standard) {
                    Text(section.title)
                        .fontWithLineHeight(.Title.medium)
                        .foregroundStyle(Color.label)
                        .fullWidth(.leading)
                        
                    VStack(spacing: Spacing.medium) {
                        let filteredItems = section.items.filter { item in
                            item.title.localizedStandardContains(searchText)
                        }
                        ForEach(searchText.isEmpty ? section.items : filteredItems) { item in
                            SettingsRowView(item: item)
                        }
                    }
                }
                .padding(.bottom, Spacing.extraLarge)
            }
            .padding(.horizontal, Padding.large)
            
            Text("v\(Bundle.main.releaseVersionNumber ?? "")")
                .fontWithLineHeight(.Body.mediumBold)
                .foregroundStyle(Color.label)
                .padding(.bottom, Spacing.extraLarge)
            
            Rectangle()
                .foregroundStyle(Color.clear)
                .frame(height: 40)
        }
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    SettingsScreen()
}
