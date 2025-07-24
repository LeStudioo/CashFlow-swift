//
//  RecommendedCategoryButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI
import StatsKit
import CoreModule

struct RecommendedCategoryButton: View {
    
    // Builder
    var transactionName: String
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
                        Image(bestCategory.icon)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                        Text("\(bestSubcategory != nil ? (bestSubcategory!.name) : (bestCategory.name))")
                            .fontWithLineHeight(.Body.small)
                    }
                    .fullWidth(.trailing)
                    .foregroundStyle(bestCategory.color)
                }
                .padding(.horizontal, 8)
                .onTapGesture {
                    selectedCategory = bestCategory
                    if let subcategoryFound { selectedSubcategory = subcategoryFound }
                    EventService.sendEvent(key: EventKeys.autocatSuggestionAccepeted)
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
        selectedCategory: .constant(.mock),
        selectedSubcategory: .constant(.mock)
    )
}
