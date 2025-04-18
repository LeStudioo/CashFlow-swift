//
//  CategoryHeader.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI

struct CategoryHeader: View {
    
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
                    Image(systemName: category.icon)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(uiColor: .systemBackground))
                }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CategoryHeader(category: .mock)
}
