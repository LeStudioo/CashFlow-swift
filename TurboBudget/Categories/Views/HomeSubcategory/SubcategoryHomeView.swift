//
//  SubcategoryHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 19/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Charts

struct SubcategoryHomeView: View {
    
    // Builder
    var category: CategoryModel
    
    // Custom
    @StateObject private var viewModel: SubcategoryHomeViewModel = .init()
    
    //Environnement
    @EnvironmentObject private var router: NavigationManager
    
    // Computed
    var searchResults: [SubcategoryModel] {
        if viewModel.searchText.isEmpty {
            return category.subcategories?
                .sorted { $0.name < $1.name } ?? []
        } else {
            return category.subcategories?
                .filter { $0.name.localizedStandardContains(viewModel.searchText) } ?? []
                .sorted { $0.name < $1.name }
        }
    }
    
    // MARK: -
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack {
                    if category.currentMonthExpenses.isEmpty && category.currentMonthIncomes.isEmpty {
                        EmptyCategoryData()
                            .padding(.bottom, 8)
                    }
                    
                    if viewModel.isDisplayChart(category: category) && viewModel.searchText.isEmpty {
                        PieChart(
                            slices: category.categorySlices,
                            backgroundColor: Color.background100,
                            configuration: .init(style: .subcategory, space: 0.2, hole: 0.75)
                        )
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.background100)
                        }
                        .padding(.bottom, 8)
                    }
                    
                    ForEach(searchResults) { subcategory in
                        NavigationButton(push: router.pushSubcategoryTransactions(subcategory: subcategory)) {
                            SubcategoryRow(subcategory: subcategory)
                        }
                        .padding(.bottom, 8)
                    }
                }
                .padding()
            } // End ScrollView
            .scrollDismissesKeyboard(.immediately)
            .scrollIndicators(.hidden)
        } // End VStack
        .blur(radius: viewModel.filter.showMenu ? 3 : 0)
        .disabled(viewModel.filter.showMenu)
        .onTapGesture { withAnimation { viewModel.filter.showMenu = false } }
        .searchable(text: $viewModel.searchText.animation(), prompt: "word_search".localized)
        .navigationTitle("word_subcategories".localized)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarDismissPushButton()
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    SubcategoryHomeView(category: .mock)
}
