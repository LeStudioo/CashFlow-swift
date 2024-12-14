//
//  TransactionDetailPredictedCategoryRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/12/2024.
//

import SwiftUI

struct TransactionDetailPredictedCategoryRow: View {
    
    // Builder
    var category: CategoryModel
    var subcategory: SubcategoryModel? = nil
    var action: (() -> Void)? = nil
    
    var icon: String {
        if let subcategory {
            return subcategory.icon
        } else { return category.icon }
    }
    
    var text: String {
        if let subcategory {
            return subcategory.name
        } else { return category.name }
    }
   
    // MARK: -
    var body: some View {
        Button {
            if let action { action() }
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    CustomOrSystemImage(systemImage: icon, size: 12)
                        .padding(6)
                        .background {
                            Circle()
                                .fill(Color.componentInComponent)
                        }
                    Text("transaction_recommended_category".localized)
                        .font(.mediumText16())
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                }
                
                Text(text)
                    .font(.semiBoldText16())
                    .foregroundStyle(Color.white)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(category.color)
            }
        }
    } // bdoy
} // struct

// MARK: - Preview
#Preview {
    TransactionDetailPredictedCategoryRow(
        category: .mock,
        subcategory: .mock
    )
}
