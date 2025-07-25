//
//  CategoryRowView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//

import SwiftUI
import TheoKit
import DesignSystemModule

struct CategoryRowView: View {
    
    // MARK: Dependencies
    var category: CategoryModel
    var selectedDate: Date
    var amount: String
            
    // MARK: - View
    var body: some View {
        HStack(spacing: Spacing.small) {
            Circle()
                .foregroundStyle(category.color)
                .frame(width: 36, height: 36)
                .overlay {
                    IconSVG(icon: category.icon, value: .medium)
                        .foregroundStyle(Color.white)
                }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(category.name)
                    .fontWithLineHeight(.Body.mediumBold)
                    .foregroundStyle(Color.label)
                    .lineLimit(1)
                
                Text(amount)
                    .fontWithLineHeight(.Body.small)
                    .animation(.smooth, value: amount)
                    .contentTransition(.numericText())
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                    .lineLimit(1)
            }
            .fullWidth(.leading)
            
            IconSVG(icon: .iconArrowRight, value: .large)
                .foregroundStyle(Color.label)
        }
        .padding(Padding.medium)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: CornerRadius.standard,
            lineWidth: 1,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
    }
}

// MARK: - Preview
#Preview {
    CategoryRowView(category: .mock, selectedDate: .now, amount: "")
}
