//
//  BudgetsHomeView.swift
//  CashFlow
//
//  Created by KaayZenn on 03/08/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import NavigationKit
import TheoKit

struct BudgetsHomeView: View {
    
    // Custom
    @ObservedObject var filter: Filter = sharedFilter
    
    // Environnement
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var budgetStore: BudgetStore
    
    // MARK: -
    var body: some View {
        ListWithBluredHeader(maxBlurRadius: DesignSystem.Blur.topbar) {
            NavigationBar(
                title: "word_budgets".localized,
                actionButton: .init(
                    title: Word.Classic.create,
                    action: { router.push(.budget(.create)) },
                    isDisabled: false
                )
            )
        } content: {
            ForEach(budgetStore.budgetsByCategory.sorted(by: { $0.key.name < $1.key.name }), id: \.key) { category, budgets in
                VStack(spacing: 16) {
                    CategoryHeaderView(category: category)
                    
                    VStack(spacing: 12) {
                        ForEach(budgets) { budget in
                            BudgetRow(budget: budget)
                                .onTapGesture {
                                    if let subcategory = budget.subcategory {
                                        router.push(.budget(.transactions(subcategory: subcategory)))
                                    }
                                }
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .padding(.bottom, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(TKDesignSystem.Colors.Background.Theme.bg50.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    BudgetsHomeView()
}
