//
//  SubcategoryListScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 19/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import NavigationKit
import TheoKit
import DesignSystemModule

struct SubcategoryListScreen: View {
    
    // MARK: Dependencies
    var category: CategoryModel
    var selectedDate: Date
    
    // MARK: Environnements
    @EnvironmentObject private var transactionStore: TransactionStore
    @EnvironmentObject private var categoryStore: CategoryStore
    
    // MARK: StateObject
    @StateObject private var viewModel: ViewModel = .init()
    
    // Computed
    var searchResults: [SubcategoryModel] {
        let subcategories = viewModel.searchText.isEmpty
            ? (category.subcategories ?? [])
            : (category.subcategories?.filter { $0.name.localizedStandardContains(viewModel.searchText) } ?? [])
        
        return subcategories.sorted { subcat1, subcat2 in
            if subcat2.name == "word_others".localized {
                return true
            }
            if subcat1.name == "word_others".localized {
                return false
            }
            return subcat1.name < subcat2.name
        }
    }
    
    // MARK: - View
    var body: some View {
        ListWithBluredHeader(maxBlurRadius: DesignSystem.Blur.topbar) {
            NavigationBar(title: "word_subcategories".localized)
        } content: {
            ForEach(searchResults) { subcategory in
                NavigationButton(
                    route: .push,
                    destination: AppDestination.subcategory(
                        .transactions(
                            subcategory: subcategory,
                            selectedDate: selectedDate
                        )
                    )
                ) {
                    SubcategoryRowView(subcategory: subcategory, selectedDate: selectedDate)
                }
                .padding(.bottom, Spacing.medium)
                .padding(.horizontal, Padding.large)
            }
            .noDefaultStyle()
        }

            //                    if viewModel.isDisplayChart(category: category) && viewModel.searchText.isEmpty { // TODO: deplace in alaytics
            //                        PieChart(
            //                            month: selectedDate,
            //                            slices: categoryStore.subcategoriesSlices(for: category, in: selectedDate),
            //                            backgroundColor: Color.background100,
            //                            configuration: .init(style: .subcategory, space: 0.2, hole: 0.75)
            //                        )
            //                        .padding()
            //                        .frame(maxWidth: .infinity)
            //                        .background {
            //                            RoundedRectangle(cornerRadius: 16, style: .continuous)
            //                                .fill(Color.background100)
            //                        }
            //                        .padding(.bottom, 8)
            //                    }
        .navigationBarBackButtonHidden(true)
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
    }
}

// MARK: - Preview
#Preview {
    SubcategoryListScreen(category: .mock, selectedDate: .now)
}
