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
    
    // Custom
    @ObservedObject var filter: Filter = sharedFilter
    
    //Environnements
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var budgetRepository: BudgetRepository
    @Environment(\.dismiss) private var dismiss
    
    //State or Binding String
    @State private var searchText: String = ""
    var months: [String] = Calendar.current.monthSymbols
    
    // Computed var
    var getAllBudgetsByCategory: [CategoryModel] {
        var array: [CategoryModel] = []
        for budget in budgetRepository.budgets {
            if let category = CategoryRepository.shared.findCategoryById(budget.categoryID), !array.contains(category) {
                array.append(category)
            }
        }
        return array
    }
    
    var searchResults: [BudgetModel] {
        if searchText.isEmpty {
            return Array(budgetRepository.budgets)
        } else { //Searching
            let budgetsFilterByTitle: [BudgetModel] = budgetRepository.budgets
                .filter { $0.name.localizedStandardContains(searchText) }
            let budgetsFilterByCategory: [BudgetModel] = budgetRepository.budgets
                .filter { CategoryRepository.shared.findCategoryById($0.categoryID)?.name.localizedStandardContains(searchText) ?? false }
            
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
            if budgetRepository.budgets.count != 0 && searchResults.count != 0 {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(getAllBudgetsByCategory, id: \.self) { category in
                            if budgetRepository.budgets.map({ CategoryRepository.shared.findCategoryById($0.categoryID)}).contains(category) {
                                if searchResults.map({ CategoryRepository.shared.findCategoryById($0.categoryID) }).contains(category) {
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
                                }
                                ForEach(searchResults) { budget in
                                    if CategoryRepository.shared.findCategoryById(budget.categoryID) == category {
                                        Button(action: {
                                            if let subcategory = CategoryRepository.shared.findSubcategoryById(budget.subcategoryID) {
                                                router.pushBudgetTransactions(subcategory: subcategory)
                                            }
                                        }, label: {
                                            BudgetRow(budget: budget, selectedDate: $filter.date)
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
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    NavigationButton(present: router.presentCreateBudget()) {
                        Label("word_add".localized, systemImage: "plus")
                    }
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
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    BudgetsHomeView()
}
