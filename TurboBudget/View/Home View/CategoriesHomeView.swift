//
//  CategoriesHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

struct CategoriesHomeView: View {
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    
    //Custom type
    @StateObject private var viewModel: CategoriesHomeViewModel = .init()
        
    //MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.categoriesFiltered.count != 0 {
                ScrollView {
                    VStack {
                        if !alertMessageIfEmpty().isEmpty {
                            Text(alertMessageIfEmpty())
                                .font(Font.mediumText16())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 8)
                        }
                        if viewModel.dataWithFilterChoosen && viewModel.searchText.isEmpty {
                            PieChart(
                                slices: PredefinedCategory.categoriesSlices,
                                backgroundColor: Color.colorCell,
                                configuration: .init(style: .category, space: 0.2, hole: 0.75)
                            )
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.colorCell)
                            }
                            .padding(.bottom, 8)
                        }
                        
                        ForEach(viewModel.categoriesFiltered) { category in
                            if category.subcategories.count != 0 {
                                Button(action: {
                                    router.pushHomeSubcategories(category: category)
                                }, label: {
                                    CategoryRow(category: category, showChevron: true)
                                        .foregroundStyle(Color(uiColor: .label))
                                })
                                .padding(.bottom, 8)
                            } else {
                                Button(action: {
                                    router.pushCategoryTransactions(category: category)
                                }, label: {
                                    CategoryRow(category: category, showChevron: true)
                                })
                                .padding(.bottom, 8)
                                .foregroundStyle(Color(uiColor: .label))
                                .disabled(!(category.transactions.count != 0))
                            }
                        }
                        
                        Rectangle().frame(height: 100).opacity(0)
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
    } // End body
    
    // MARK: Functions
    func alertMessageIfEmpty() -> String {
        if viewModel.filter.byDay
            && !viewModel.dataWithFilterChoosen
            && viewModel.categoriesFiltered
            .map({ $0.incomesTransactionsAmountForSelectedDate(filter: viewModel.filter) })
            .reduce(0, +) == 0 {
            return "⚠️" + " " + "error_message_no_data_day".localized
        } else if !viewModel.filter.byDay && !viewModel.dataWithFilterChoosen && !viewModel.filter.total {
            return "⚠️" + " " + "error_message_no_data_month".localized
        }
        return ""
    }
    
} // End struct

// MARK: - Preview
#Preview {
    CategoriesHomeView()
}
