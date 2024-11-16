//
//  SubcategoryHomeViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 04/07/2024.
//

import Foundation

final class SubcategoryHomeViewModel: ObservableObject {
    @Published var selectedSubcategory: PredefinedSubcategory? = nil
    @Published var filter: Filter = .shared
    
    @Published var searchText: String = ""
}

extension SubcategoryHomeViewModel {
    
    func isDisplayChart(category: PredefinedCategory) -> Bool {
        if !filter.automation && !filter.total {
            if category.subcategories.map({ $0.transactionsAmount(type: .expense, filter: filter) }).reduce(0, +) > 0 { return true } else { return false }
        } else if filter.automation && !filter.total {
            if category.subcategories.map({ $0.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date) }).reduce(0, +) > 0 { return true } else { return false }
        } else if !filter.automation && filter.total {
            if category.subcategories.map({ $0.amountTotalOfExpenses }).reduce(0, +) > 0 { return true } else { return false }
        } else if filter.automation && filter.total {
            if category.subcategories.map({ $0.amountTotalOfExpensesAutomations }).reduce(0, +) > 0 { return true } else { return false }
        }
        return false
    }
    
}
