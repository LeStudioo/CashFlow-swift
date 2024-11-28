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
    
    //Custom
    @EnvironmentObject private var categoryRepository: CategoryRepository
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    
    //State or Binding String
    @State private var searchText: String = ""

    // Computed variables
    var categoriesFiltered: [CategoryModel] {
        return categoryRepository.categories
            .searchFor(searchText)
            .filter { !$0.isRevenue }
    }
    
    //MARK: - Body
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
                        if category.subcategories?.count == 0 {
                            cellForCategory(category: category)
                                .onTapGesture {
                                    withAnimation {
                                        selectedSubcategory = nil
                                        selectedCategory = category
                                        dismiss()
                                    }
                                }
                                .overlay(alignment: .topTrailing) {
                                    if selectedCategory == category {
                                        ZStack {
                                            Circle()
                                                .frame(width: 25, height: 25)
                                                .foregroundStyle(ThemeManager.theme.color)
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12, weight: .heavy, design: .rounded))
                                                .foregroundStyle(.white)
                                        }
                                        .padding(8)
                                    }
                                }
                        } else {
                            VStack {
                                let subcategories: [SubcategoryModel] = searchText.isEmpty
                                ? category.subcategories ?? []
                                : category.subcategories?.filter { $0.name.localizedStandardContains(searchText) } ?? []
                                ForEach(subcategories) { subcategory in
                                    cellForSubcategory(subcategory: subcategory)
                                        .onTapGesture {
                                            withAnimation {
                                                selectedCategory = category
                                                selectedSubcategory = subcategory
                                                dismiss()
                                            }
                                        }
                                        .overlay(alignment: .topTrailing) {
                                            if selectedSubcategory == subcategory {
                                                ZStack {
                                                    Circle()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(ThemeManager.theme.color)
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                                                        .foregroundStyle(.white)
                                                }
                                                .padding(8)
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
                        Image("NoResults\(ThemeManager.theme.nameNotLocalized.capitalized)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 4, y: 4)
                            .frame(width: isIPad
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
                            .foregroundStyle(Color(uiColor: .label))
                            .font(.system(size: 18, weight: .semibold))
                    })
                }
            }
        } //End Navigation Stack
        .searchable(text: $searchText.animation(), placement: .navigationBarDrawer(displayMode: .always), prompt: "word_search".localized)
    }//END body
    
    //MARK: - ViewBuilder
    func cellForSubcategory(subcategory: SubcategoryModel) -> some View {
        HStack {
            Circle()
                .foregroundStyle(subcategory.color)
                .frame(width: 35, height: 35)
                .overlay {
                    Group {
                        if let _ = UIImage(systemName: subcategory.icon) {
                            Image(systemName: subcategory.icon)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(.black)
                        } else {
                            Image("\(subcategory.icon)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25)
                        }
                    }
                }
            
            Text(subcategory.name)
                .font(.semiBoldSmall())
                .foregroundStyle(Color(uiColor: .label))
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal, 12).padding(.vertical, 16)
        .background(Color.componentInComponent)
        .cornerRadius(15)
    }
    
    func cellForCategory(category: CategoryModel) -> some View {
        HStack {
            Circle()
                .foregroundStyle(category.color)
                .frame(width: 35, height: 35)
                .overlay {
                    Image(systemName: category.icon)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                }
            
            Text(category.name)
                .font(.semiBoldSmall())
                .foregroundStyle(Color(uiColor: .label))
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal, 12).padding(.vertical, 16)
        .background(Color.componentInComponent)
        .cornerRadius(15)
    }
    
}//END struct

//MARK: - Preview
//struct WhatCategoryView_Previews: PreviewProvider {
//
//    @State static var selectedCategoryPreview: ? = previewCategory1()
//    @State static var selectedSubcategoryPreview: ? =
//
//    static var previews: some View {
//        SelectCategoryView(selectedCategory: $selectedCategoryPreview, selectedSubcategory: )
//    }
//}
