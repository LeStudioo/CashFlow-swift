//
//  CategoryHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

struct CategoryHomeView: View {
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var transactionStore: TransactionStore
    
    // Custom type
    @StateObject private var viewModel: CategoriesHomeViewModel = .init()
    
    @State private var selectedDate: Date = Date()
    
    // MARK: -
    var body: some View {
        ScrollView {
            if viewModel.categoriesFiltered.isNotEmpty {
                VStack(spacing: 24) {
                    if viewModel.isChartDisplayed {
                        EmptyCategoryData()
                            .padding(8)
                    } else if viewModel.searchText.isEmpty {
                        PieChart(
                            month: selectedDate,
                            slices: CategoryStore.shared.categoriesSlices(for: selectedDate),
                            backgroundColor: Color.background100,
                            configuration: .init(style: .category, space: 0.2, hole: 0.75)
                        )
                        .padding(8)
                    }
                    
                    VStack(spacing: 8) {
                        SwitchDateButton(date: $selectedDate, type: .month)
                        SwitchDateButton(date: $selectedDate, type: .year)
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
                    Group {
                        if let subcategories, !subcategories.isEmpty {
                            NavigationButton(push: router.pushHomeSubcategories(category: category, selectedDate: selectedDate)) {
                                CategoryRow(category: category, selectedDate: selectedDate)
                            }
                        } else {
                            NavigationButton(push: router.pushCategoryTransactions(category: category, selectedDate: selectedDate)) {
                                CategoryRow(category: category, selectedDate: selectedDate)
                            }
                        }
                    }
                    .foregroundStyle(Color.text)
                    .padding(.bottom, 8)
                }
                
                Rectangle()
                    .frame(height: 100)
                    .opacity(0)
            } else {
                ErrorView(
                    searchResultsCount: viewModel.categoriesFiltered.count,
                    searchText: viewModel.searchText,
                    image: "",
                    text: ""
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
        .onChange(of: selectedDate) { _ in
            if let account = accountStore.selectedAccount, let accountID = account.id {
                Task {
                    await transactionStore.fetchTransactionsByPeriod(
                        accountID: accountID,
                        startDate: selectedDate,
                        endDate: selectedDate.endOfMonth
                    )
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CategoryHomeView()
}
