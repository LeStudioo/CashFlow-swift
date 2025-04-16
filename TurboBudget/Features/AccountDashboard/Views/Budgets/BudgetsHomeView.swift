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
    
    // Environnement
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var budgetStore: BudgetStore
    
    // MARK: -
    var body: some View {
        List(budgetStore.budgetsByCategory.sorted(by: { $0.key.name < $1.key.name }), id: \.key) { category, budgets in
            VStack(spacing: 16) {
                CategoryHeader(category: category)
                
                VStack(spacing: 12) {
                    ForEach(budgets) { budget in
                        BudgetRow(budget: budget)
                            .onTapGesture {
                                if let subcategory = budget.subcategory {
                                    router.pushBudgetTransactions(subcategory: subcategory)
                                }
                            }
                    }
                }
            }
            .listRowSeparator(.hidden)
            .padding(.bottom, 8)
        }
        .listStyle(.plain)
        .navigationTitle("word_budgets".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationButton(present: router.presentCreateBudget()) {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.text)
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
