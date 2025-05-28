//
//  CategoryHeaderView.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI

struct CategoryHeaderView: View {
    
    // Builder
    var category: CategoryModel
    
    // MARK: -
    var body: some View {
        HStack(spacing: 8) {
            Text(category.name)
                .font(.mediumCustom(size: 22))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle(category.color)
                .overlay {
                    IconSVG(icon: category.icon, value: .small) // TODO: Verify
                        .foregroundStyle(Color.white)
                }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CategoryHeaderView(category: .mock)
}
