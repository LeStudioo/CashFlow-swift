//
//  WhatCategoryView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

struct WhatCategoryView: View {
    
    //Custom type
    @Binding var selectedCategory: PredefinedCategory?
    @Binding var selectedSubcategory: PredefinedSubcategory?
    var predefinedCategories = PredefinedObjectManager.shared.allPredefinedCategory
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding String
    @State private var searchText: String = ""
    
    //State or Binding Int, Float and Double
    @State private var offsetValidationButton: CGFloat = 120
    
    //State or Binding Bool
    @State private var showAlertPaywall: Bool = false
    @State private var showPaywall: Bool = false
    
    //State or Binding Date
    
    //Enum
    
    //Computed var
    var searchResults: [PredefinedCategory] {
        if searchText.isEmpty {
            return predefinedCategories.sorted { $0.title < $1.title }
        } else { //Searching
            let categoryFilterByTitle: [PredefinedCategory] = predefinedCategories.filter { $0.title.localizedCaseInsensitiveContains(searchText) }.sorted { $0.title < $1.title }
            
            if categoryFilterByTitle.isEmpty {
                var subcategories: [PredefinedSubcategory] = []
                
                for category in predefinedCategories {
                    for subcategory in category.subcategories { 
                        subcategories.append(subcategory)
                    }
                }
                
                let filterSubcategories = subcategories.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
                
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
                                            .foregroundColor(category.color)
                                            .overlay {
                                                Image(systemName: category.icon)
                                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                    .foregroundColor(.colorLabelInverse)
                                            }
                                    }
                                    .padding([.horizontal, .top])
                                    if category.subcategories.count == 0 {
                                        cellForCategory(category: category)
                                            .onTapGesture { withAnimation { selectedSubcategory = nil; selectedCategory = category } }
                                            .overlay(alignment: .topTrailing) {
                                                if selectedCategory == category {
                                                    ZStack {
                                                        Circle()
                                                            .frame(width: 25, height: 25)
                                                            .foregroundColor(HelperManager().getAppTheme().color)
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                                                            .foregroundColor(.white)
                                                    }
                                                    .padding(8)
                                                }
                                            }
                                    } else {
                                        VStack {
                                            ForEach(category.subcategories) { subcategory in
                                                cellForSubcategory(subcategory: subcategory)
                                                    .onTapGesture { withAnimation { selectedCategory = subcategory.category; selectedSubcategory = subcategory } }
                                                    .overlay(alignment: .topTrailing) {
                                                        if selectedSubcategory == subcategory {
                                                            ZStack {
                                                                Circle()
                                                                    .frame(width: 25, height: 25)
                                                                    .foregroundColor(HelperManager().getAppTheme().color)
                                                                Image(systemName: "checkmark")
                                                                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                                                                    .foregroundColor(.white)
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
                    .overlay(alignment: .bottom) {
                        if searchResults.count != 0 {
                            ValidateButton(action: { dismiss() }, validate: true)
                                .offset(y: offsetValidationButton)
                                .onChange(of: selectedCategory) { newValue in
                                    if newValue != nil {
                                        withAnimation(.spring().speed(1.2)) { offsetValidationButton = 0 }
                                    }
                                }
                                .onChange(of: selectedSubcategory) { newValue in
                                    if newValue != nil {
                                        withAnimation(.spring().speed(1.2)) { offsetValidationButton = 0 }
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.bottom)
                                .if(offsetValidationButton != 120) { view in
                                    view
                                        .background(
                                            LinearGradient(stops: [
                                                Gradient.Stop(color: Color.color2Apple.opacity(0), location: 0.00),
                                                Gradient.Stop(color: Color.color2Apple, location: 1.00)
                                            ], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.27))
                                        )
                                }
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Image("NoResults\(themeSelected)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 4, y: 4)
                            .frame(width: isIPad ? (orientation.isLandscape ? UIScreen.main.bounds.width / 3 : UIScreen.main.bounds.width / 2) : UIScreen.main.bounds.width / 1.5 )
                        
                        Text("word_no_results".localized + " '\(searchText)'")
                            .font(.semiBoldText16())
                            .multilineTextAlignment(.center)
                    }
                    .offset(y: -20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } //End VStack
            .background(Color.color2Apple.edgesIgnoringSafeArea(.all))
            .navigationTitle("what_category_title".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.colorLabel)
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
                .foregroundColor(subcategory.category.color)
                .frame(width: 35, height: 35)
                .overlay {
                    Group {
                        if let _ = UIImage(systemName: subcategory.icon) {
                            Image(systemName: subcategory.icon)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
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
                .foregroundColor(.colorLabel)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal, 8).padding(.vertical, 16)
        .background(Color.colorCell)
        .cornerRadius(15)
    }
    
    func cellForCategory(category: PredefinedCategory) -> some View {
        HStack {
            Circle()
                .foregroundColor(category.color)
                .frame(width: 35, height: 35)
                .overlay {
                    Image(systemName: category.icon)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                }
            
            Text(category.title)
                .font(.semiBoldSmall())
                .foregroundColor(.colorLabel)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal, 8).padding(.vertical, 16)
        .background(Color.colorCell)
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
//        WhatCategoryView(selectedCategory: $selectedCategoryPreview, selectedSubcategory: )
//    }
//}
