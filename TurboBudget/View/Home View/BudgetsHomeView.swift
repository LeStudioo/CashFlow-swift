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
    
    //Environnement
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var budgetRepository: BudgetRepository
    
    // MARK: -
    var body: some View {
        List(budgetRepository.budgetsByCategory.sorted(by: { $0.key.name < $1.key.name }), id: \.key) { category, budgets in
            CategoryHeader(category: category)
                .padding([.horizontal, .top])
            
            ForEach(budgets) { budget in
                Button {
                    if let subcategory = budget.subcategory {
                        router.pushBudgetTransactions(subcategory: subcategory)
                    }
                } label: {
                    BudgetRow(budget: budget)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("word_budgets".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationButton(present: router.presentCreateBudget()) {
                    Image(systemName: "plus")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    BudgetsHomeView()
}
