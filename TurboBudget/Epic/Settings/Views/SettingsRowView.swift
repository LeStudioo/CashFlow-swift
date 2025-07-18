//
//  SettingsRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/05/2025.
//

import SwiftUI
import TheoKit
import NavigationKit
import AlertKit
import DesignSystemModule

struct SettingsRowView: View {
    
    // MARK: Dependencies
    var item: SettingItemModel
    
    // MARK: Environment
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var router: Router<AppDestination>
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - View
    var body: some View {
        HStack(spacing: TKDesignSystem.Spacing.medium) {
            Image(item.icon)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.white)
                .frame(width: 16, height: 16)
                .padding(Padding.small)
                .roundedRectangleBorder(
                    item.color,
                    radius: TKDesignSystem.Radius.small
                )
            
            Text(item.title)
                .fontWithLineHeight(DesignSystem.Fonts.Body.medium)
                .foregroundStyle(Color.label)
                .fullWidth(.leading)
            
            Image(item.isPush == true ? .iconArrowRight : .iconArrowUpRight)
                .renderingMode(.template)
                .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                
        }
        .padding(Padding.medium)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: TKDesignSystem.Radius.standard,
            lineWidth: 1,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
        .onTapGesture {
            item.action(router: router, alertManager: alertManager, dismiss: dismiss)
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsRowView(item: .appearance)
}
