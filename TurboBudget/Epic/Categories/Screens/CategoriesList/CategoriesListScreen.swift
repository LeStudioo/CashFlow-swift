//
//  CategoriesListScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import NavigationKit
import TheoKit
import DesignSystemModule

struct CategoriesListScreen: View {
    
    // MARK: EnvironmentObject
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var transactionStore: TransactionStore
    @EnvironmentObject private var categoryStore: CategoryStore
    @EnvironmentObject private var router: Router<AppDestination>
    
    // MARK: StateObject
    @StateObject private var viewModel: ViewModel = .init()
    
    // MARK: -
    var body: some View {
        VStack(spacing: 0) {
            ListWithBluredHeader(maxBlurRadius: DesignSystem.Blur.topbar) {
                NavigationBar(
                    title: "word_categories".localized,
                    withDismiss: false,
                    actionButton: .init(
                        icon: .iconGear,
                        action: { router.push(.settings(.home)) },
                        isDisabled: false
                    ),
                    placeholder: "word_search".localized,
                    searchText: $viewModel.searchText.animation(),
                )
            } content: {
                if viewModel.categoriesFiltered.isNotEmpty {
                    ForEach(viewModel.categoriesFiltered) { category in
                        let subcategories = category.subcategories
                        NavigationButton(
                            route: .push,
                            destination: (
                                subcategories?.isEmpty == false
                                ? AppDestination.subcategory(.list(category: category, selectedDate: viewModel.selectedDate))
                                : AppDestination.category(.transactions(category: category, selectedDate: viewModel.selectedDate))
                            )
                        ) {
                            CategoryRowView(
                                category: category,
                                selectedDate: viewModel.selectedDate,
                                amount: (viewModel.categoryAmounts[category.id]?.amount ?? 0).toCurrency()
                            )
                        }
                        .padding(.bottom, TKDesignSystem.Spacing.medium)
                    }
                    .noDefaultStyle()
                    .padding(.horizontal, Padding.large)
                    
                    Rectangle()
                        .frame(height: 100)
                        .opacity(0)
                        .noDefaultStyle()
                } else {
                    CustomEmptyView(
                        type: .noResults(viewModel.searchText),
                        isDisplayed: viewModel.categoriesFiltered.isEmpty && !viewModel.searchText.isEmpty
                    )
                }
            }
            
            //                VStack(spacing: 24) { // TODO: deplace in analytics
            //                    if !viewModel.isChartDisplayed {
            //                        EmptyCategoryData()
            //                            .padding(8)
            //                    } else if viewModel.searchText.isEmpty {
            //                        PieChart(
            //                            month: viewModel.selectedDate,
            //                            slices: CategoryStore.shared.categoriesSlices(for: viewModel.selectedDate),
            //                            backgroundColor: Color.background100,
            //                            configuration: .init(style: .category, space: 0.2, hole: 0.75)
            //                        )
            //                        .padding(8)
            //                    }
            //
            //                    VStack(spacing: 8) {
            //                        SwitchDateButton(date: $viewModel.selectedDate, type: .month)
            //                        SwitchDateButton(date: $viewModel.selectedDate, type: .year)
            //                    }
            //                }
            //                .padding(8)
            //                .frame(maxWidth: .infinity)
            //                .background {
            //                    RoundedRectangle(cornerRadius: 16, style: .continuous)
            //                        .fill(Color.background100)
            //                }
            //                .padding(.bottom, 8)
        } // VStack
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .onAppear {
            viewModel.calculateAllAmounts(for: viewModel.selectedDate)
        }
        .refreshable {
            await categoryStore.fetchCategories()
        }
        .onChange(of: viewModel.selectedDate) { _ in
            if let account = accountStore.selectedAccount, let accountID = account._id {
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
    CategoriesListScreen()
}
