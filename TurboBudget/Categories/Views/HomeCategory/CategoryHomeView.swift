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
    @EnvironmentObject private var categoryRepository: CategoryStore
    
    //Custom type
    @StateObject private var viewModel: CategoriesHomeViewModel = .init()
        
    //MARK: -
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.categoriesFiltered.count != 0 {
                ScrollView {
                    VStack {
                        if categoryRepository.currentMonthExpenses.isEmpty && categoryRepository.currentMonthIncomes.isEmpty {
                            EmptyCategoryData()
                                .padding(.bottom, 8)
                        } else if viewModel.searchText.isEmpty {
                            PieChart(
                                slices: CategoryStore.shared.categoriesSlices,
                                backgroundColor: Color.background100,
                                configuration: .init(style: .category, space: 0.2, hole: 0.75)
                            )
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.background100)
                            }
                            .padding(.bottom, 8)
                        }
                        
                        ForEach(viewModel.categoriesFiltered) { category in
                            let subcategories = category.subcategories
                            Group {
                                if let subcategories, !subcategories.isEmpty {
                                    NavigationButton(push: router.pushHomeSubcategories(category: category)) {
                                        CategoryRow(category: category, showChevron: true)
                                    }
                                } else {
                                    NavigationButton(push: router.pushCategoryTransactions(category: category)) {
                                        CategoryRow(category: category, showChevron: true)
                                    }
                                }
                            }
                            .foregroundStyle(Color.text)
                            .padding(.bottom, 8)
                        }
                        
                        Rectangle()
                            .frame(height: 100)
                            .opacity(0)
                    }
                    .padding()
                } //End ScrollView
                .scrollDismissesKeyboard(.immediately)
                .scrollIndicators(.hidden)
            } else {
                ErrorView(
                    searchResultsCount: viewModel.categoriesFiltered.count,
                    searchText: viewModel.searchText,
                    image: "",
                    text: ""
                )
            }
        } // End VStack
        .blur(radius: viewModel.filter.showMenu ? 3 : 0)
        .disabled(viewModel.filter.showMenu)
        .onTapGesture { withAnimation { viewModel.filter.showMenu = false } }
        .searchable(text: $viewModel.searchText.animation(), prompt: "word_search".localized)
        .navigationTitle("word_categories")
        .navigationBarTitleDisplayMode(.large)
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    CategoryHomeView()
}
