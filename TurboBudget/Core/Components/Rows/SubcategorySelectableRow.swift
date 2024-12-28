//
//  SubcategorySelectableRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import SwiftUI

struct SubcategorySelectableRow: View {
    
    // Builder
    var subcategory: SubcategoryModel
    var isSelected: Bool
    var action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .foregroundStyle(subcategory.color)
                    .frame(width: 35, height: 35)
                    .overlay {
                        CustomOrSystemImage(
                            systemImage: subcategory.icon,
                            size: 16
                        )
                    }
                
                Text(subcategory.name)
                    .font(.semiBoldSmall())
                    .foregroundStyle(Color(uiColor: .label))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 12)
            .padding(.vertical)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.background300)
            }
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
    SubcategorySelectableRow(subcategory: .mock, isSelected: true, action: { })
}
