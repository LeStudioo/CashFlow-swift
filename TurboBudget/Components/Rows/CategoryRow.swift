//
//  CategoryRow.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//

import SwiftUI

struct CategoryRow: View {
    
    // Builder
    var category: CategoryModel
    var showChevron: Bool?
    
    // Custom
    @ObservedObject var filter: Filter = sharedFilter
	
    // TODO: - Refacto
	// Computed variables
    var stringAmount: String {
        if category.isRevenue {
            return category.currentMonthIncomes.reduce(0) { $0 + ($1.amount ?? 0) }.currency
        } else {
            return category.currentMonthExpenses.reduce(0) { $0 + ($1.amount ?? 0) }.currency
        }
    }

    // MARK: -
    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(category.color)
                .frame(width: 45, height: 45)
                .overlay {
                    Image(systemName: category.icon)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.semiBoldCustom(size: 20))
                    .lineLimit(1)
                
                Text(stringAmount)
                    .font(.semiBoldText18())
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if let showChevron, showChevron {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(uiColor: .label))
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
        }
        .padding()
        .padding(.trailing, 8)
        .background(Color.colorCell)
        .cornerRadius(15)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CategoryRow(category: .mock)
}
