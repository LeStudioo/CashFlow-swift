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
    var router: NavigationManager
    var category: PredefinedCategory
    
    // Custom
    @StateObject private var viewModel: SubcategoryHomeViewModel = .init()
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    
    //State or Binding Int, Float and Double
    @State private var height: CGFloat = 0
    
    // Computed
    var searchResults: [PredefinedSubcategory] {
        if viewModel.searchText.isEmpty {
            return category.subcategories
                .sorted { $0.title < $1.title }
        } else {
            return category.subcategories
                .sorted { $0.title < $1.title }
                .filter { $0.title.localizedStandardContains(viewModel.searchText) }
        }
    }
    
    //MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack {
                    if !alertMessageIfEmpty().isEmpty {
                        HStack {
                            Text(alertMessageIfEmpty())
                                .font(Font.mediumText16())
                            Spacer()
                        }
                        .padding(.bottom, 8)
                    }
                    if viewModel.isDisplayChart(category: category) && viewModel.searchText.isEmpty {
                        PieChart(
                            slices: category.categorySlices,
                            backgroundColor: Color.colorCell,
                            configuration: .init(style: .subcategory, space: 0.2, hole: 0.75)
                        )
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.colorCell)
                        }
                        .padding(.bottom, 8)
                    }
                    
                    ForEach(searchResults) { subcategory in
                        Button(action: {
                            router.pushSubcategoryTransactions(subcategory: subcategory)
                        }, label: {
                            SubcategoryRow(subcategory: subcategory)
                        })
                        .padding(.bottom, 8)
                        .disabled(!dataAvailableForSubcategoryWithFilter(subcategory: subcategory))
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(uiColor: .label))
                })
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // End body
    
    // MARK: - Functions
    func dataAvailableForSubcategoryWithFilter(subcategory: PredefinedSubcategory) -> Bool {
        if viewModel.filter.total && subcategory.transactions.count != 0 { return true }
        if subcategory.expensesTransactionsAmountForSelectedDate(filter: viewModel.filter) != 0 { return true }
        return false
    }
    
    func alertMessageIfEmpty() -> String {
        if viewModel.filter.byDay && !viewModel.isDisplayChart(category: category) {
            return "⚠️" + " " + "error_message_no_data_day".localized
        } else if !viewModel.filter.byDay && !viewModel.isDisplayChart(category: category) && !viewModel.filter.total {
            return "⚠️" + " " + "error_message_no_data_month".localized
        }
        return ""
    }
    
} // End struct

// MARK: - Preview
#Preview {
    SubcategoryHomeView(
        router: .init(isPresented: .constant(.homeSubcategories(category: .PREDEFCAT1))),
        category: .PREDEFCAT1
    )
}
