//
//  RecommendedCategoryButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI

struct RecommendedCategoryButton: View {
    
    // Builder
    var transactionTitle: String
    @Binding var transactionType: ExpenseOrIncome
    @Binding var selectedCategory: PredefinedCategory?
    @Binding var selectedSubcategory: PredefinedSubcategory?
    
    // MARK: -
    var body: some View {
        let bestCategory = TransactionEntity.findBestCategory(for: transactionTitle)
        
        if let categoryFound = bestCategory.0 {
            let subcategoryFound = bestCategory.1
            HStack {
                Text(Word.Classic.recommended + " : ")
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: categoryFound.icon)
                    Text("\(subcategoryFound != nil ? subcategoryFound!.title : categoryFound.title)")
                }
                .foregroundStyle(categoryFound.color)
            }
            .font(.system(size: 14, weight: .medium))
            .padding(.horizontal, 8)
            .onTapGesture {
                if categoryFound == PredefinedCategory.PREDEFCAT0 {
                    withAnimation { transactionType = .income }
                } else {
                    selectedCategory = categoryFound
                    withAnimation { transactionType = .expense }
                }
                if let subcategoryFound { selectedSubcategory = subcategoryFound }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    RecommendedCategoryButton(
        transactionTitle: "Test",
        transactionType: .constant(.expense),
        selectedCategory: .constant(PredefinedCategory.PREDEFCAT1),
        selectedSubcategory: .constant(PredefinedSubcategory.PREDEFSUBCAT1CAT1)
    )
}
