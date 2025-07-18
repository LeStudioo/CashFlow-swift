//
//  NavigationBarWithMenu.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/05/2025.
//

import SwiftUI
import TheoKit
import DesignSystemModule

struct NavigationBarWithMenu<Content: View>: View {
    
    // MARK: Dependencies
    var title: String?
    @ViewBuilder var content: () -> Content
    var dismissAction: (() -> Void)?
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - View
    var body: some View {
        HStack(spacing: TKDesignSystem.Spacing.small) {
            VStack(alignment: .leading, spacing: TKDesignSystem.Spacing.small) {
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
                
                if let title {
                    Text(title)
                        .fontWithLineHeight(DesignSystem.Fonts.Title.large)
                        .foregroundStyle(Color.label)
                }
            }
            
            Spacer()
            
            Menu(content: content) {
                Image(.iconEllipsis)
                    .renderingMode(.template)
                    .foregroundStyle(Color.label)
            }
        }
        .padding(.horizontal, Padding.large)
    }
}

#Preview {
    NavigationBarWithMenu {
        
    }
}
