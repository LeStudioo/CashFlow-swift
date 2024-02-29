//
//  SelectCategoryButtonView.swift
//  CashFlow
//
//  Created by KaayZenn on 27/02/2024.
//

import SwiftUI

struct SelectCategoryButtonView: View {
    
    // Builder
    var router: NavigationManager
    @Binding var selectedCategory: PredefinedCategory?
    @Binding var selectedSubcategory: PredefinedSubcategory?
    
    // Computed variables
    var widthCircleCategory: CGFloat {
        return isLittleIphone ? 80 : 100
    }
    
    // MARK: - body
    var body: some View {
        Button(action: {
            router.presentSelectCategory(
                category: $selectedCategory,
                subcategory: $selectedSubcategory
            )
        }, label: {
            if let selectedCategory, let selectedSubcategory {
                ZStack {
                    Circle()
                        .frame(width: widthCircleCategory, height: widthCircleCategory)
                        .foregroundColor(selectedCategory.color)
                    
                    Image(systemName: selectedSubcategory.icon)
                        .font(.system(size: isLittleIphone ? 26 : 32, weight: .bold, design: .rounded))
                        .foregroundColor(.colorLabelInverse)
                }
            } else if let selectedCategory,
                      selectedSubcategory == nil {
                ZStack {
                    Circle()
                        .frame(width: widthCircleCategory, height: widthCircleCategory)
                        .foregroundColor(selectedCategory.color)
                    
                    Image(systemName: selectedCategory.icon)
                        .font(.system(size: isLittleIphone ? 26 : 32, weight: .bold, design: .rounded))
                        .foregroundColor(.colorLabelInverse)
                }
            } else {
                ZStack {
                    Circle()
                        .frame(width: widthCircleCategory, height: widthCircleCategory)
                        .foregroundStyle(Color.backgroundComponentSheet)
                    
                    Image(systemName: "plus")
                        .font(.system(size: isLittleIphone ? 26 : 32, weight: .regular, design: .rounded))
                        .foregroundColor(.colorLabel)
                }
            }
        })
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SelectCategoryButtonView(
        router: .init(isPresented: .constant(.selectCategory(category: .constant(nil), subcategory: .constant(nil)))),
        selectedCategory: .constant(nil),
        selectedSubcategory: .constant(nil)
    )
}
