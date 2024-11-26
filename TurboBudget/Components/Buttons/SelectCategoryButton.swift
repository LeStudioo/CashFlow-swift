//
//  SelectCategoryButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI

struct SelectCategoryButton: View {
    
    // Builder
    @Binding var type: TransactionType
    @Binding var selectedCategory: CategoryModel?
    @Binding var selectedSubcategory: SubcategoryModel?
    
    @EnvironmentObject private var router: NavigationManager
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Word.Classic.category.capitalized)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            NavigationButton(
                present: router.presentSelectCategory(
                    category: $selectedCategory,
                    subcategory: $selectedSubcategory
                )
            ) {
                HStack(spacing: 8) {
                    if let selectedSubcategory, selectedCategory != nil {
                        CustomOrSystemImage(
                            systemImage: selectedSubcategory.icon,
                            size: 16
                        )
                        
                        Text(selectedSubcategory.title)
                    } else if let selectedCategory, selectedSubcategory == nil {
                        Image(systemName: selectedCategory.icon)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.black)
                        
                        Text(selectedCategory.title)
                    } else {
                        Image(systemName: "plus")
                        Text(Word.Create.addCategory)
                    }
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(selectedCategory != nil ? Color.black : Color.label)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(selectedCategory?.color ?? Color.backgroundComponentSheet)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onChange(of: type) { newValue in
            if newValue == .income {
                selectedCategory = CategoryModel.revenue
                selectedSubcategory = nil
            } else if newValue == .expense && selectedCategory == CategoryModel.revenue {
                selectedCategory = nil
                selectedSubcategory = nil
            }
        }
        .onChange(of: selectedCategory) { newValue in
            if newValue != CategoryModel.revenue && newValue != CategoryModel.toCategorized {
                type = .expense
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SelectCategoryButton(
        type: .constant(.expense),
        selectedCategory: .constant(nil),
        selectedSubcategory: .constant(nil)
    )
    .padding()
    .background(Color.background)
}
