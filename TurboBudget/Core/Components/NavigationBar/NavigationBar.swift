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
    var withDismiss: Bool = true
    var actionButton: NavigationBar.ActionButton?
    var dismissAction: (() -> Void)?
    
    var placeholder: String = ""
    @Binding var searchText: String
    
    init(
        title: String? = nil,
        withDismiss: Bool = true,
        actionButton: NavigationBar.ActionButton? = nil,
        dismissAction: (() -> Void)? = nil,
        placeholder: String = "",
        searchText: Binding<String> = .constant("")
    ) {
        self.title = title
        self.withDismiss = withDismiss
        self.actionButton = actionButton
        self.dismissAction = dismissAction
        self.placeholder = placeholder
        self._searchText = searchText
    }
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: TKDesignSystem.Spacing.standard) {
            VStack(alignment: .leading, spacing: TKDesignSystem.Spacing.small) {
                HStack(spacing: TKDesignSystem.Spacing.small) {
                    if withDismiss {
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
                                    .fontWithLineHeight(DesignSystem.Fonts.Body.medium)
                            }
                            
                        }
                        .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                    }
                    
                    if let actionButton {
                        Button {
                            Task {
                                await actionButton.action()
                            }
                        } label: {
                            if let icon = actionButton.icon {
                                Image(icon)
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.label)
                            } else if let title = actionButton.title {
                                Text(title)
                                    .fontWithLineHeight(DesignSystem.Fonts.Body.large)
                                    .foregroundStyle(themeManager.theme.color)
                            }
                        }
                        .fullWidth(.trailing)
                        .disabled(actionButton.isDisabled)
                        .opacity(actionButton.isDisabled ? 0.5 : 1)
                    }
                }
                
                if let title {
                    Text(title)
                        .fontWithLineHeight(DesignSystem.Fonts.Title.large)
                        .foregroundStyle(Color.label)
                }
            }
            
            if !placeholder.isEmpty {
                SearchBarView(placeholder, searchText: $searchText)
            }
        }
        .fullWidth(.leading)
        .padding(TKDesignSystem.Padding.large)
    } // body
} // struct

extension NavigationBar {
    
    struct ActionButton {
        var title: String?
        var icon: ImageResource?
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
