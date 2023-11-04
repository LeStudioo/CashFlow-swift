//
//  CategoriesHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import Charts

struct CategoriesHomeView: View {
    
    //Custom type
    @State private var selectedCategory: PredefinedCategory? = nil
    @ObservedObject var filter: Filter = sharedFilter
    var categories = PredefinedObjectManager.shared.allPredefinedCategory
    
    //Environnements
    
    //State or Binding String
    @State private var searchText: String = ""
    
    //State or Binding Int, Float and Double
    @State private var height: CGFloat = 0
    @State private var offsetYFilterView: CGFloat = 0
    
    //State or Binding Bool
    @State private var showAddCategory: Bool = false
    
    //State or Binding Date
    
    //Enum
    
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
            let isCategoryEmpty: Bool = predefCategories.sorted { $0.title < $1.title }.filter { $0.title.localizedCaseInsensitiveContains(searchText) }.isEmpty
            
            if isCategoryEmpty {
                var subcategories: [PredefinedSubcategory] = []
                
                for category in predefCategories {
                    for subcategory in category.subcategories {
                        subcategories.append(subcategory)
                    }
                }
                
                let filterSubcategories = subcategories.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
                
                var categories: [PredefinedCategory] = []
                for subcategory in filterSubcategories {
                    if !categories.contains(subcategory.category) {
                        categories.append(subcategory.category)
                    }
                }
                
                return categories.sorted { $0.title < $1.title }
            } else {
                return predefCategories.sorted { $0.title < $1.title }.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    var valueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.decimalSeparator = ""
        formatter.groupingSeparator = ""
        return formatter
    }()
    
    //Binding update
    @Binding var update: Bool
    
    //MARK: - Body
    var body: some View {
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
                                            height: $height,
                                            update: $update
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
                                NavigationLink(destination: { 
                                    SubcategoryHomeView(category: category, update: $update)
                                }, label: {
                                    CategoryRow(category: category, showChevron: true, update: $update)
                                        .padding(.bottom, 8)
                                })
                                .foregroundColor(.colorLabel)
                            } else {
                                NavigationLink(destination: { 
                                    CategoryTransactionsView(category: category, update: $update)
                                }, label: {
                                    CategoryRow(category: category, showChevron: true, update: $update)
                                        .padding(.bottom, 8)
                                })
                                .foregroundColor(.colorLabel)
                                .disabled(!(category.transactions.count != 0))
                            }
                        }
                        
                        Rectangle().frame(height: 100).opacity(0)
                    }
                    .padding()
                } //End ScrollView
            } else {
                ErrorView(
                    searchResultsCount: searchResults.count,
                    searchText: searchText,
                    image: "",
                    text: ""
                )
            }
        } // End VStack
        .padding(update ? 0 : 0)
        .blur(radius: filter.showMenu ? 3 : 0)
        .disabled(filter.showMenu)
        .onTapGesture { withAnimation { filter.showMenu = false } }
        .searchable(text: $searchText.animation(), prompt: NSLocalizedString("word_search", comment: ""))
        .navigationTitle("word_categories")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    filter.fromBudget = false
                    filter.fromAnalytics = false
                    filter.showMenu.toggle()
                }, label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.colorLabel)
                })
            }
        }
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
    }//END body
    
    //MARK: Fonctions
    func alertMessageIfEmpty() -> String {
        if filter.byDay && !dataWithFilterChoosen && searchResults.map({ $0.incomesTransactionsAmountForSelectedDate(filter: filter) }).reduce(0, +) == 0 {
            return "⚠️" + " " + NSLocalizedString("error_message_no_data_day", comment: "")
        } else if !filter.byDay && !dataWithFilterChoosen && !filter.total {
            return "⚠️" + " " + NSLocalizedString("error_message_no_data_month", comment: "")
        }
        return ""
    }
    
}//END struct

//MARK: - Preview
#Preview {
    CategoriesHomeView(update: Binding.constant(false))
}
