//
//  SelectCategoryButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI
import NavigationKit
import TheoKit
import DesignSystemModule
import CoreModule

struct SelectCategoryButton: View {
    
    // Builder
    @Binding var selectedCategory: CategoryModel?
    @Binding var selectedSubcategory: SubcategoryModel?
        
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Word.Classic.category.capitalized)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            NavigationButton(
                route: .sheet,
                destination: AppDestination.category(
                    .select(
                        selectedCategory: $selectedCategory,
                        selectedSubcategory: $selectedSubcategory
                    )
                )
            ) {
                HStack(spacing: 8) {
                    if let selectedSubcategory, selectedCategory != nil {
                        IconSVG(icon: selectedSubcategory.icon, value: .medium)
                        Text(selectedSubcategory.name)
                    } else if let selectedCategory, selectedSubcategory == nil {
                        IconSVG(icon: selectedCategory.icon, value: .medium)
                        Text(selectedCategory.name)
                    } else {
                        Image(.iconFolderPlus)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                        Text(Word.Create.addCategory)
                    }
                }
                .fontWithLineHeight(.Body.medium)
                .foregroundStyle(Color.white)
                .padding(Padding.regular)
                .fullWidth(.leading)
                .roundedRectangleBorder(
                    selectedCategory?.color ?? TKDesignSystem.Colors.Background.Theme.bg100,
                    radius: CornerRadius.medium,
                    lineWidth: selectedCategory == nil ? 1 : 0,
                    strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
                )
            }
        }
        .fullWidth(.leading)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SelectCategoryButton(
        selectedCategory: .constant(nil),
        selectedSubcategory: .constant(nil)
    )
    .padding()
    .background(Color.Background.bg50)
}
