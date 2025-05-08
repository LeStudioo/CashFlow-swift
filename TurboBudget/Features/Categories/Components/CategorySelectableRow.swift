//
//  CategorySelectableRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import SwiftUI

struct CategorySelectableRow: View {
    
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
                        Image(category.icon) // TODO: Verify
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.white)
                            .frame(width: 16, height: 16)
                    }
                
                Text(category.name)
                    .font(.semiBoldSmall())
                    .foregroundStyle(Color.text)
                    .lineLimit(1)
                
                Spacer()
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
    CategorySelectableRow(
        category: .mock,
        isSelected: true
    ) { }
}
