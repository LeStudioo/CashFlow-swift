//
//  CategoriesHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

struct CategoriesHomeView: View {
    
    // Builder
    var router: NavigationManager
    
    //Custom type
    @State private var selectedCategory: PredefinedCategory? = nil
    @ObservedObject var filter: Filter = sharedFilter
    var categories = PredefinedObjectManager.shared.allPredefinedCategory
        
    //State or Binding String
    @State private var searchText: String = ""
    
    //State or Binding Int, Float and Double
    @State private var height: CGFloat = 0
    
    //Computed var
    var dataWithFilterChoosen: Bool {
        if !filter.automation && !filter.total {
            if categories.map({ $0.expensesTransactionsAmountForSelectedDate(filter: filter) }).reduce(0, +) > 0 { return true } else { return false }
        } else if filter.automation && !filter.total {
            if categories.map({ $0.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date) }).reduce(0, +) > 0 { return true } else { return false }
        } else if !filter.automation && filter.total {
            if categories.map({ $0.amountTotalOfExpenses }).reduce(0, +) > 0 { return true } else { return false }
        } else if filter.automation && filter.total {
            if categories.map({ $0.amountTotalOfExpensesAutomations }).reduce(0, +) > 0 { return true } else { return false }
        }
        return false
    }
    
    var searchResults: [PredefinedCategory] {
        let predefCategories = categories
 
        if searchText.isEmpty {
            return predefCategories.sorted { $0.title < $1.title }
        } else {
            let isCategoryEmpty: Bool = predefCategories.sorted { $0.title < $1.title }.filter { $0.title.unaccent().localizedCaseInsensitiveContains(searchText.unaccent()) }.isEmpty
            
            if isCategoryEmpty {
                var subcategories: [PredefinedSubcategory] = []
                
                for category in predefCategories {
                    for subcategory in category.subcategories {
                        subcategories.append(subcategory)
                    }
                }
                
                let filterSubcategories = subcategories.filter { $0.title.unaccent().localizedCaseInsensitiveContains(searchText.unaccent()) }
                
                var categories: [PredefinedCategory] = []
                for subcategory in filterSubcategories {
                    if !categories.contains(subcategory.category) {
                        categories.append(subcategory.category)
                    }
                }
                
                return categories.sorted { $0.title < $1.title }
            } else {
                return predefCategories.sorted { $0.title < $1.title }.filter { $0.title.unaccent().localizedCaseInsensitiveContains(searchText.unaccent()) }
            }
        }
    }
    
    //MARK: - Body
    var body: some View {
        NavStack(router: router) {
            VStack(spacing: 0) {
                if searchResults.count != 0 {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            if !alertMessageIfEmpty().isEmpty {
                                HStack {
                                    Text(alertMessageIfEmpty())
                                        .font(Font.mediumText16())
                                    Spacer()
                                }
                                .padding(.bottom, 8)
                            }
                            if dataWithFilterChoosen && searchText.isEmpty {
                                VStack {
                                    ZStack(alignment: .topTrailing) {
                                        HStack {
                                            Spacer()
                                            PieChartView(
                                                categories: categories,
                                                selectedCategory: $selectedCategory,
                                                height: $height
                                            )
                                            .frame(height: height)
                                            .id(filter.id)
                                            Spacer()
                                        }
                                        .padding()
                                        .background(Color.colorCell)
                                        .cornerRadius(15)
                                    }
                                }
                                .padding(.bottom, 8)
                            }
                            
                            ForEach(searchResults) { category in
                                if category.subcategories.count != 0 {
                                    Button(action: {
                                        router.pushHomeSubcategories(category: category)
                                    }, label: {
                                        CategoryRow(category: category, showChevron: true)
                                            .foregroundStyle(Color(uiColor: .label))
                                    })
                                    .padding(.bottom, 8)
                                } else {
                                    Button(action: {
                                        router.pushCategoryTransactions(category: category)
                                    }, label: {
                                        CategoryRow(category: category, showChevron: true)
                                    })
                                    .padding(.bottom, 8)
                                    .foregroundStyle(Color(uiColor: .label))
                                    .disabled(!(category.transactions.count != 0))
                                }
                            }
                            
                            Rectangle().frame(height: 100).opacity(0)
                        }
                        .padding()
                    } //End ScrollView
                    .scrollDismissesKeyboard(.immediately)
                } else {
                    ErrorView(
                        searchResultsCount: searchResults.count,
                        searchText: searchText,
                        image: "",
                        text: ""
                    )
                }
            } // End VStack
            .blur(radius: filter.showMenu ? 3 : 0)
            .disabled(filter.showMenu)
            .onTapGesture { withAnimation { filter.showMenu = false } }
            .searchable(text: $searchText.animation(), prompt: "word_search".localized)
            .navigationTitle("word_categories")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.background.edgesIgnoringSafeArea(.all))
        } // End NavStack
    } // End body
    
    // MARK: Functions
    func alertMessageIfEmpty() -> String {
        if filter.byDay && !dataWithFilterChoosen && searchResults.map({ $0.incomesTransactionsAmountForSelectedDate(filter: filter) }).reduce(0, +) == 0 {
            return "⚠️" + " " + "error_message_no_data_day".localized
        } else if !filter.byDay && !dataWithFilterChoosen && !filter.total {
            return "⚠️" + " " + "error_message_no_data_month".localized
        }
        return ""
    }
    
} // End struct

// MARK: - Preview
#Preview {
    CategoriesHomeView(router: .init(isPresented: .constant(.homeCategories)))
}
