//
//  SubcategorySelectableRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import SwiftUI
import TheoKit
import DesignSystemModule

struct SubcategorySelectableRowView: View {
    
    // MARK: Dependencies
    var subcategory: SubcategoryModel
    var isSelected: Bool
    var action: () -> Void
    
    // MARK: Environments
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - View
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .foregroundStyle(subcategory.color)
                    .frame(width: 35, height: 35)
                    .overlay {
                        IconSVG(icon: subcategory.icon, value: .standard)
                            .foregroundStyle(Color.white)
                    }
                
                Text(subcategory.name)
                    .font(.semiBoldSmall())
                    .foregroundStyle(Color.text)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(Padding.standard)
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
    SubcategorySelectableRowView(subcategory: .mock, isSelected: true, action: { })
}
