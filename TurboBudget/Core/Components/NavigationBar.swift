//
//  NavigationBar.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/05/2025.
//

import SwiftUI
import TheoKit

struct NavigationBar: View {
    
    var title: String?
    var actionButton: NavigationBar.ActionButton?
    var dismissAction: (() -> Void)?
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: TKDesignSystem.Spacing.small) {
            HStack(spacing: TKDesignSystem.Spacing.small) {
                HStack(spacing: TKDesignSystem.Spacing.extraSmall) {
                    Button {
                        if let dismissAction {
                            dismissAction()
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(.iconArrowLeft)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                        Text("word_return".localized)
                            .font(DesignSystem.Fonts.Body.medium)
                    }

                }
                .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                
                if let actionButton {
                    Button {
                        Task {
                            await actionButton.action()
                        }
                    } label: {
                        Text(actionButton.title)
                            .font(DesignSystem.Fonts.Body.large)
                            .foregroundStyle(themeManager.theme.color)
                            .fullWidth(.trailing)
                    }
                    .disabled(actionButton.isDisabled)
                    .opacity(actionButton.isDisabled ? 0.5 : 1)
                }
            }
            
            if let title {
                Text(title)
                    .font(DesignSystem.Fonts.Title.large)
                    .foregroundStyle(Color.label)
            }
        }
        .fullWidth(.leading)
        .padding(TKDesignSystem.Padding.large)
    } // body
} // struct

extension NavigationBar {
 
    struct ActionButton {
        var title: String
        var action: () async -> Void
        var isDisabled: Bool = true
    }
    
}

// MARK: - Preview
#Preview {
    NavigationBar(
        title: "Preview Test",
        actionButton: .init(
            title: "Create",
            action: { }
        )
    )
        .environmentObject(ThemeManager.shared)
}
