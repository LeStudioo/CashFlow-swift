//
//  BudgetsHomeView.swift
//  CashFlow
//
//  Created by KaayZenn on 03/08/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

struct BudgetsHomeView: View {
    
    // Builder
    var router: NavigationManager
    
    // Custom
    var categories = PredefinedObjectManager.shared.allPredefinedCategory
    @ObservedObject var filter: Filter = sharedFilter
    
    //CoreData
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Budget.title, ascending: true)])
    private var budgets: FetchedResults<Budget>
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    
    //State or Binding String
    @State private var searchText: String = ""
    var months: [String] = Calendar.current.monthSymbols
    
    // Computed var
    var getAllBudgetsByCategory: [PredefinedCategory] {
        var array: [PredefinedCategory] = []
        for budget in budgets {
            if let category = PredefinedCategoryManager().categoryByUniqueID(idUnique: budget.predefCategoryID), !array.contains(category) {
                array.append(category)
            }
        }
        return array
    }
    
    var searchResults: [Budget] {
        if searchText.isEmpty {
            return Array(budgets)
        } else { //Searching
            let budgetsFilterByTitle: [Budget] = budgets.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            let budgetsFilterByCategory: [Budget] = budgets.filter { PredefinedCategoryManager().categoryByUniqueID(idUnique: $0.predefCategoryID)?.title.localizedStandardContains(searchText) ?? false }
            
            if budgetsFilterByTitle.isEmpty {
                return budgetsFilterByCategory
            } else {
                return budgetsFilterByTitle
            }
        }
    }
    
    //MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            if budgets.count != 0 && searchResults.count != 0 {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(getAllBudgetsByCategory, id: \.self) { category in
                            if budgets.map({ PredefinedCategoryManager().categoryByUniqueID(idUnique: $0.predefCategoryID) }).contains(category) {
                                if searchResults.map({ PredefinedCategoryManager().categoryByUniqueID(idUnique: $0.predefCategoryID) }).contains(category) {
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
                                }
                                ForEach(searchResults) { budget in
                                    if PredefinedCategoryManager().categoryByUniqueID(idUnique: budget.predefCategoryID) == category {
                                        Button(action: {
                                            if let subcategory = PredefinedSubcategoryManager().subcategoryByUniqueID(subcategories: category.subcategories, idUnique: budget.predefSubcategoryID) {
                                                router.pushBudgetTransactions(subcategory: subcategory)
                                            }
                                        }, label: {
                                            CellBudgetView(budget: budget, selectedDate: $filter.date)
                                        })
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                    }
                                }
                            }
                        }
                    }
                } //End ScrollView
                .blur(radius: filter.showMenu ? 3 : 0)
                .disabled(filter.showMenu)
                .onTapGesture { withAnimation { filter.showMenu = false } }
            } else {
                ErrorView(
                    searchResultsCount: searchResults.count,
                    searchText: searchText,
                    image: "NoBudgets",
                    text: "budgets_home_no_budget".localized
                )
            }
        }
        .navigationTitle("word_budgets".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(uiColor: .label))
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button(action: {
                        router.presentCreateBudget()
                    }, label: {
                        Label("word_add".localized, systemImage: "plus")
                    })
                    Button(action: {
                        filter.fromBudget = true; filter.showMenu = true
                    }, label: {
                        Label("word_month".localized, systemImage: "calendar")
                    })
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
        }
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    BudgetsHomeView(router: .init(isPresented: .constant(.allBudgets)))
}
