//
//  CategoriesHomeViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 04/07/2024.
//

import Foundation

final class CategoriesHomeViewModel: ObservableObject {
    
    let categories = PredefinedCategory.allCases
    let filter: Filter = .shared
    
    @Published var selectedCategory: PredefinedCategory? = nil
    
    @Published var searchText: String = ""
}

extension CategoriesHomeViewModel {
    
    var dataWithFilterChoosen: Bool {
        if !filter.automation && !filter.total {
            if categories
                .map({ $0.transactionsAmount(type: .expense, filter: filter) }).reduce(0, +) > 0 { return true } else { return false }
        } else if filter.automation && !filter.total {
            if categories
                .map({ $0.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date) }).reduce(0, +) > 0 { return true } else { return false }
        } else if !filter.automation && filter.total {
            if categories
                .map({ $0.amountTotalOfExpenses }).reduce(0, +) > 0 { return true } else { return false }
        } else if filter.automation && filter.total {
            if categories
                .map({ $0.amountTotalOfExpensesAutomations }).reduce(0, +) > 0 { return true } else { return false }
        }
        return false
    }
    
    var categoriesFiltered: [PredefinedCategory] {
        return categories.searchFor(searchText)
    }
        
}
