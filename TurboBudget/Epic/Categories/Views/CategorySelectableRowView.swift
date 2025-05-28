//
//  CategorySelectableRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import SwiftUI
import TheoKit

struct CategorySelectableRowView: View {
    
    // Builder
    var category: CategoryModel
    var isSelected: Bool
    var action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .foregroundStyle(category.color)
                    .frame(width: 35, height: 35)
                    .overlay {
                        IconSVG(icon: category.icon, value: .standard)
                            .foregroundStyle(Color.white)
                    }
                
                Text(category.name)
                    .font(.semiBoldSmall())
                    .foregroundStyle(Color.text)
                    .lineLimit(1)
                
                Spacer()
            }
            .padding(TKDesignSystem.Padding.standard)
            .roundedRectangleBorder(
                TKDesignSystem.Colors.Background.Theme.bg200,
                radius: TKDesignSystem.Radius.standard
            )
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    ZStack {
                        Circle()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(themeManager.theme.color)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    .padding(8)
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CategorySelectableRowView(
        category: .mock,
        isSelected: true
    ) { }
}
