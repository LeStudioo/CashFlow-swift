//
//  SelectCategoryView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

struct SelectCategoryView: View {
    
    // Builder
    @Binding var selectedCategory: CategoryModel?
    @Binding var selectedSubcategory: SubcategoryModel?
    
    // Custom
    @EnvironmentObject private var categoryStore: CategoryStore
    @EnvironmentObject private var themeManager: ThemeManager
    
    // Environnements
    @Environment(\.dismiss) private var dismiss
    
    // State or Binding String
    @State private var searchText: String = ""
    
    // Computed variables
    var categoriesFiltered: [CategoryModel] {
        return categoryStore.categories
            .filter { !$0.isRevenue }
            .searchFor(searchText)
    }
    
    // MARK: -
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(categoriesFiltered) { category in
                    VStack {
                        HStack {
                            Text(category.name)
                                .font(.mediumCustom(size: 22))
                            Spacer()
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(category.color)
                                .overlay {
                                    Image(systemName: category.icon)
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundStyle(Color(uiColor: .systemBackground))
                                }
                        }
                        .padding([.horizontal, .top])
                        if category.subcategories == nil || category.subcategories?.isEmpty == true {
                            CategorySelectableRow(
                                category: category,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation {
                                    selectedSubcategory = nil
                                    selectedCategory = category
                                    dismiss()
                                }
                            }
                        } else {
                            VStack {
                                let subcategories: [SubcategoryModel] = searchText.isEmpty
                                ? category.subcategories ?? []
                                : category.subcategories?.filter { $0.name.localizedStandardContains(searchText) } ?? []
                                ForEach(subcategories) { subcategory in
                                    SubcategorySelectableRow(
                                        subcategory: subcategory,
                                        isSelected: selectedSubcategory == subcategory
                                    ) {
                                        withAnimation {
                                            selectedCategory = category
                                            selectedSubcategory = subcategory
                                            dismiss()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                Rectangle()
                    .frame(height: 60)
                    .opacity(0)
                
                Spacer()
            }
            .scrollIndicators(.hidden)
            .overlay {
                if !searchText.isEmpty && categoriesFiltered.isEmpty {
                    VStack(spacing: 20) {
                        Image("NoResults\(themeManager.theme.nameNotLocalized.capitalized)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 4, y: 4)
                            .frame(width: UIDevice.isIpad
                                   ? UIScreen.main.bounds.width / 3
                                   : UIScreen.main.bounds.width / 1.5
                            )
                        
                        Text("word_no_results".localized + " '\(searchText)'")
                            .font(.semiBoldText16())
                            .multilineTextAlignment(.center)
                    }
                    .offset(y: -20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("what_category_title".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.text)
                            .font(.system(size: 18, weight: .semibold))
                    })
                }
            }
        } // Navigation Stack
        .searchable(text: $searchText.animation(), placement: .navigationBarDrawer(displayMode: .always), prompt: "word_search".localized)
    } // body
} // struct

// MARK: - Preview
// struct WhatCategoryView_Previews: PreviewProvider {
//
//    @State static var selectedCategoryPreview: ? = previewCategory1()
//    @State static var selectedSubcategoryPreview: ? =
//
//    static var previews: some View {
//        SelectCategoryView(selectedCategory: $selectedCategoryPreview, selectedSubcategory: )
//    }
// }
