//
//  BudgetsTransactionsView.swift
//  CashFlow
//
//  Created by KaayZenn on 17/08/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

struct BudgetsTransactionsView: View {

    // Builder
    var subcategory: SubcategoryModel
    
    @EnvironmentObject private var budgetRepository: BudgetRepository

    // Environment
    @EnvironmentObject private var router: NavigationManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    // String variables
    @State private var searchText: String = ""

    // Number variables
    @State private var newAmount: Double = 0.0
    
    // Boolean variables
    @State private var ascendingOrder: Bool = false
    @State private var showEditMaxAmount: Bool = false
    @State private var showDeleteBudget: Bool = false

	// Computed variables
    var searchResults: [TransactionModel] {
        var array: [TransactionModel] = []
        if searchText.isEmpty {
            if ascendingOrder {
                array = subcategory.expenses
                    .sorted { $0.amount ?? 0 < $1.amount ?? 0 }.reversed()
            } else {
                array = subcategory.expenses
                    .sorted { $0.amount ?? 0 < $1.amount ?? 0 }
            }
        } else { array = subcategory.transactions.filter { $0.name.localizedCaseInsensitiveContains(searchText) } }
        
        return array.filter { $0.date > Date().startOfMonth && $0.date < Date().endOfMonth }
    }
    
    // Other
    var numberFormatter: NumberFormatter {
        let numFor = NumberFormatter()
        numFor.numberStyle = .decimal
        numFor.zeroSymbol = ""
        return numFor
    }
    
    // MARK: - body
    var body: some View {
        VStack {
            if subcategory.transactions.count != 0 && searchResults.count != 0{
                List(subcategory.currentMonthExpenses) { transaction in
                    Section {
                        NavigationButton(push: router.pushTransactionDetail(transaction: transaction)) {
                            TransactionRow(transaction: transaction)
                        }
                        .listRowSeparator(.hidden)
                    } header: {
                        detailForExpenses()
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            } else { // No Transaction
                ErrorView(
                    searchResultsCount: searchResults.count,
                    searchText: searchText,
                    image: "NoTransaction",
                    text: "budgets_transactions_no_transaction".localized
                )
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationTitle("word_transactions".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .alert("budgets_transactions_delete_budget".localized, isPresented: $showDeleteBudget, actions: {
            Button(role: .cancel, action: { return }, label: { Text("word_cancel".localized) })
            Button(role: .destructive, action: {
                if let budget = subcategory.budget, let budgetID = budget.id {
                    Task {
                        await budgetRepository.deleteBudget(budgetID: budgetID)
                        dismiss()
                    }
                }
            }, label: { Text("word_delete".localized) })
        }, message: {
            Text("budgets_transactions_delete_budget_desc".localized)
        })
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button(action: { showEditMaxAmount.toggle() }, label: { Label("budgets_transactions_button_edit".localized, systemImage: "pencil") })
                    Button(role: .destructive, action: { showDeleteBudget.toggle() }, label: { Label("word_delete".localized, systemImage: "trash") })
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
        }
        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // End body
    
    //MARK: ViewBuilder
    @ViewBuilder
    func detailForExpenses() -> some View {
        HStack {
            HStack(alignment: .bottom) {
                Text(searchResults.map({ $0.amount ?? 0 }).reduce(0, +).toCurrency())
                    .font(.mediumCustom(size: 22))
                Spacer()
//                Button(action: { withAnimation { ascendingOrder.toggle() } }, label: {
//                    HStack {
//                        Text("word_expenses".localized)
//                        Image(systemName: "arrow.up")
//                            .rotationEffect(.degrees(ascendingOrder ? 180 : 0))
//                    }
//                })
//                .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
//                .font(.semiBoldSmall())
            }
            .font(.mediumCustom(size: 22))
            
            Spacer()
        }
        .padding([.horizontal, .top])
    }
} // End struct

// MARK: - Preview
#Preview {
    BudgetsTransactionsView(subcategory: .mock)
}
