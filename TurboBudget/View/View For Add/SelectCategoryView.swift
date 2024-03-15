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
    @Binding var selectedCategory: PredefinedCategory?
    @Binding var selectedSubcategory: PredefinedSubcategory?
    
    //Custom
    var predefinedCategories = PredefinedObjectManager.shared.allPredefinedCategory
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding String
    @State private var searchText: String = ""
    
    //State or Binding Bool
    @State private var showAlertPaywall: Bool = false
    @State private var showPaywall: Bool = false
    
    // Computed variables
    var searchResults: [PredefinedCategory] {
        if searchText.isEmpty {
            return predefinedCategories.sorted { $0.title < $1.title }
        } else { //Searching
            let categoryFilterByTitle: [PredefinedCategory] = predefinedCategories.filter { $0.title.unaccent().localizedCaseInsensitiveContains(searchText.unaccent()) }.sorted { $0.title < $1.title }
            
            if categoryFilterByTitle.isEmpty {
                var subcategories: [PredefinedSubcategory] = []
                
                for category in predefinedCategories {
                    for subcategory in category.subcategories { 
                        subcategories.append(subcategory)
                    }
                }
                
                let filterSubcategories = subcategories.filter { $0.title.unaccent().localizedCaseInsensitiveContains(searchText.unaccent()) }
                
                var categories: [PredefinedCategory] = []
                for subcategory in filterSubcategories {
                    if let category = PredefinedCategoryManager().categoryByUniqueID(idUnique: subcategory.category.idUnique), !categories.contains(category) {
                        categories.append(category)
                    }
                }
                
                return categories.sorted { $0.title < $1.title }
            } else {
                return categoryFilterByTitle
            }
        }
    }
    
    //MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                if searchResults.count != 0 {
                    ScrollView(showsIndicators: false) {
                        ForEach(searchResults, id: \.self) { category in
                            if category != categoryPredefined0 {
                                VStack {
                                    HStack {
                                        Text(category.title)
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
                                    if category.subcategories.count == 0 {
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
                                                            .foregroundStyle(HelperManager().getAppTheme().color)
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                                                            .foregroundStyle(.white)
                                                    }
                                                    .padding(8)
                                                }
                                            }
                                    } else {
                                        let categoryFilterByTitle: [PredefinedCategory] = predefinedCategories.filter { $0.title.unaccent().localizedCaseInsensitiveContains(searchText.unaccent()) }.sorted { $0.title < $1.title }

                                        VStack {
                                            ForEach(searchText.isEmpty || (!searchText.isEmpty && !categoryFilterByTitle.isEmpty)
                                                    ? category.subcategories
                                                    : category.subcategories.filter { $0.title.unaccent().localizedCaseInsensitiveContains(searchText.unaccent()) }
                                            ) { subcategory in
                                                cellForSubcategory(subcategory: subcategory)
                                                    .onTapGesture {
                                                        withAnimation {
                                                            selectedCategory = subcategory.category
                                                            selectedSubcategory = subcategory
                                                            dismiss()
                                                        }
                                                    }
                                                    .overlay(alignment: .topTrailing) {
                                                        if selectedSubcategory == subcategory {
                                                            ZStack {
                                                                Circle()
                                                                    .frame(width: 25, height: 25)
                                                                    .foregroundStyle(HelperManager().getAppTheme().color)
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
                            } //End if let
                        }
                        
                        Rectangle()
                            .frame(height: 60)
                            .opacity(0)
                        
                        Spacer()
                    }
                } else {
                    VStack(spacing: 20) {
                        Image("NoResults\(themeSelected)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 4, y: 4)
                            .frame(width: isIPad
                                   ? (OrientationManager.shared.orientation.isLandscape ? UIScreen.main.bounds.width / 3 : UIScreen.main.bounds.width / 2)
                                   : UIScreen.main.bounds.width / 1.5
                            )
                        
                        Text("word_no_results".localized + " '\(searchText)'")
                            .font(.semiBoldText16())
                            .multilineTextAlignment(.center)
                    }
                    .offset(y: -20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } //End VStack
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
        .alert("alert_cashflow_pro_title".localized, isPresented: $showAlertPaywall, actions: {
            Button(action: { return }, label: { Text("word_cancel".localized) })
            Button(action: { showPaywall.toggle() }, label: { Text("alert_cashflow_pro_see".localized) })
        }, message: {
            Text("alert_cashflow_pro_desc".localized)
        })
        .sheet(isPresented: $showPaywall) { PaywallScreenView() }
    }//END body
    
    //MARK: - ViewBuilder
    func cellForSubcategory(subcategory: PredefinedSubcategory) -> some View {
        HStack {
            Circle()
                .foregroundStyle(subcategory.category.color)
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
            
            Text(subcategory.title)
                .font(.semiBoldSmall())
                .foregroundStyle(Color(uiColor: .label))
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal, 12).padding(.vertical, 16)
        .background(Color.componentInComponent)
        .cornerRadius(15)
    }
    
    func cellForCategory(category: PredefinedCategory) -> some View {
        HStack {
            Circle()
                .foregroundStyle(category.color)
                .frame(width: 35, height: 35)
                .overlay {
                    Image(systemName: category.icon)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                }
            
            Text(category.title)
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
