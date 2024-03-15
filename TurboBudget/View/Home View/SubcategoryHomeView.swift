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
    @ObservedObject var category: PredefinedCategory
    
    // Custom
    @State private var selectedSubcategory: PredefinedSubcategory? = nil
    @ObservedObject var filter: Filter = sharedFilter
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    
    //State or Binding String
    @State private var searchText: String = ""
    
    //State or Binding Int, Float and Double
    @State private var height: CGFloat = 0
    
    //State or Binding Bool
    
    //State or Binding Date
    
    //Enum
    
    //Computed var
    var isDisplayChart: Bool {
        if !filter.automation && !filter.total {
            if category.subcategories.map({ $0.expensesTransactionsAmountForSelectedDate(filter: filter) }).reduce(0, +) > 0 { return true } else { return false }
        } else if filter.automation && !filter.total {
            if category.subcategories.map({ $0.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date) }).reduce(0, +) > 0 { return true } else { return false }
        } else if !filter.automation && filter.total {
            if category.subcategories.map({ $0.amountTotalOfExpenses }).reduce(0, +) > 0 { return true } else { return false }
        } else if filter.automation && filter.total {
            if category.subcategories.map({ $0.amountTotalOfExpensesAutomations }).reduce(0, +) > 0 { return true } else { return false }
        }
        return false
    }
    
    var subcategoryWithTheHighestAmount: Double {
        return category.subcategories.map { $0.amountTotalOfExpenses }.sorted { $0 < $1 }.last!
    }
    
    var searchResults: [PredefinedSubcategory] {
        if searchText.isEmpty {
            return category.subcategories.sorted { $0.title < $1.title }
        } else {
            return category.subcategories.sorted { $0.title < $1.title }.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var valueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.decimalSeparator = ""
        formatter.groupingSeparator = ""
        return formatter
    }()
    
    //MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack {
                    if !alertMessageIfEmpty().isEmpty {
                        HStack {
                            Text(alertMessageIfEmpty())
                                .font(Font.mediumText16())
                            Spacer()
                        }
                        .padding(.bottom, 8)
                    }
                    if isDisplayChart && searchText.isEmpty {
                        HStack {
                            Spacer()
                            PieChartSubcategoryView(
                                subcategories: category.subcategories,
                                selectedSubcategory: $selectedSubcategory,
                                height: $height
                            )
                            .frame(height: height)
                            .id(filter.id)
                            Spacer()
                        }
                        .padding(.vertical)
                        .padding(.horizontal)
                        .background(Color.colorCell)
                        .cornerRadius(15)
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
        } // End VStack
        .blur(radius: filter.showMenu ? 3 : 0)
        .disabled(filter.showMenu)
        .onTapGesture { withAnimation { filter.showMenu = false } }
        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    filter.fromBudget = false
                    filter.fromAnalytics = false
                    filter.showMenu.toggle()
                }, label: {
                    Image(systemName: "calendar")
                        .foregroundStyle(Color(uiColor: .label))
                })
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // End body
    
    // MARK: - Functions
    func dataAvailableForSubcategoryWithFilter(subcategory: PredefinedSubcategory) -> Bool {
        if filter.total && subcategory.transactions.count != 0 { return true }
        if subcategory.expensesTransactionsAmountForSelectedDate(filter: filter) != 0 { return true }
        return false
    }
    
    func alertMessageIfEmpty() -> String {
        if filter.byDay && !isDisplayChart {
            return "⚠️" + " " + "error_message_no_data_day".localized
        } else if !filter.byDay && !isDisplayChart && !filter.total {
            return "⚠️" + " " + "error_message_no_data_month".localized
        }
        return ""
    }
    
} // End struct

// MARK: - Preview
#Preview {
    SubcategoryHomeView(
        router: .init(isPresented: .constant(.homeSubcategories(category: categoryPredefined1))),
        category: categoryPredefined1
    )
}
