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
                    Image(category.icon) // TODO: Verify
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.white)
                        .frame(width: 14, height: 14)
                }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CategoryHeader(category: .mock)
}
