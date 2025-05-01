//
//  RecommendedCategoryButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI
import StatsKit

struct RecommendedCategoryButton: View {
    
    // Builder
    var transactionName: String
    @Binding var type: TransactionType
    @Binding var selectedCategory: CategoryModel?
    @Binding var selectedSubcategory: SubcategoryModel?
    
    @State private var bestCategory: CategoryModel?
    @State private var bestSubcategory: SubcategoryModel?
    
    // MARK: -
    var body: some View {
        VStack {
            if let bestCategory {
                let subcategoryFound = bestSubcategory
                HStack(spacing: 8) {
                    Text(Word.Classic.recommended + " : ")
                    HStack(spacing: 4) {
                        Image(systemName: bestCategory.icon)
                        Text("\(bestSubcategory != nil ? (bestSubcategory!.name) : (bestCategory.name))")
                    }
                    .foregroundStyle(bestCategory.color)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 8)
                .onTapGesture {
                    if selectedCategory?.isRevenue == true {
                        withAnimation { type = .income }
                    } else {
                        selectedCategory = bestCategory
                        withAnimation { type = .expense }
                    }
                    if let subcategoryFound { selectedSubcategory = subcategoryFound }
                    EventService.sendEvent(key: .autocatSuggestionAccepeted)
                }
            }
        }
        .onChange(of: transactionName) { newValue in
            if newValue.count > 3 {
                Task {
                    if let response = await TransactionStore.shared.fetchCategory(name: transactionName) {
                        bestCategory = CategoryStore.shared.findCategoryById(response.cat)
                        bestSubcategory = CategoryStore.shared.findSubcategoryById(response.sub)
                    }
                }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    RecommendedCategoryButton(
        transactionName: "Test",
        type: .constant(.expense),
        selectedCategory: .constant(.mock),
        selectedSubcategory: .constant(.mock)
    )
}
