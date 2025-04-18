//
//  CategoryHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import NavigationKit

struct CategoryHomeView: View {
    
    // Environment
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var transactionStore: TransactionStore
    
    // Custom type
    @StateObject private var viewModel: CategoriesHomeViewModel = .init()
    
    // MARK: -
    var body: some View {
        ScrollView {
            if viewModel.categoriesFiltered.isNotEmpty {
                VStack(spacing: 24) {
                    if !viewModel.isChartDisplayed {
                        EmptyCategoryData()
                            .padding(8)
                    } else if viewModel.searchText.isEmpty {
                        PieChart(
                            month: viewModel.selectedDate,
                            slices: CategoryStore.shared.categoriesSlices(for: viewModel.selectedDate),
                            backgroundColor: Color.background100,
                            configuration: .init(style: .category, space: 0.2, hole: 0.75)
                        )
                        .padding(8)
                    }
                    
                    VStack(spacing: 8) {
                        SwitchDateButton(date: $viewModel.selectedDate, type: .month)
                        SwitchDateButton(date: $viewModel.selectedDate, type: .year)
                    }
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.background100)
                }
                .padding(.bottom, 8)
                
                ForEach(viewModel.categoriesFiltered) { category in
                    let subcategories = category.subcategories
                    NavigationButton(
                        route: .push,
                        destination: (subcategories?.isEmpty == false
                        ? AppDestination.subcategory(.list(category: category, selectedDate: viewModel.selectedDate))
                        : AppDestination.category(.transactions(category: category, selectedDate: viewModel.selectedDate)))
                    ) {
                        CategoryRow(
                            category: category,
                            selectedDate: viewModel.selectedDate,
                            amount: (viewModel.categoryAmounts[category.id]?.amount ?? 0).toCurrency()
                        )
                    }
                    .foregroundStyle(Color.text)
                    .padding(.bottom, 8)
                }
                
                Rectangle()
                    .frame(height: 100)
                    .opacity(0)
            } else {
                CustomEmptyView(
                    type: .noResults(viewModel.searchText),
                    isDisplayed: viewModel.categoriesFiltered.isEmpty && !viewModel.searchText.isEmpty
                )
            }
        } // ScrollView
        .padding(.horizontal)
        .scrollDismissesKeyboard(.immediately)
        .scrollIndicators(.hidden)
        .searchable(text: $viewModel.searchText.animation(), prompt: "word_search".localized)
        .navigationTitle("word_categories")
        .navigationBarTitleDisplayMode(.large)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.calculateAllAmounts(for: viewModel.selectedDate)
        }
        .onChange(of: viewModel.selectedDate) { _ in
            if let account = accountStore.selectedAccount, let accountID = account.id {
                Task {
                    await transactionStore.fetchTransactionsByPeriod(
                        accountID: accountID,
                        startDate: viewModel.selectedDate,
                        endDate: viewModel.selectedDate.endOfMonth
                    )
                    viewModel.calculateAllAmounts(for: viewModel.selectedDate)
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CategoryHomeView()
}
