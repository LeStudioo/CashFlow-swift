//
//  CategoriesHomeViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 04/07/2024.
//

import Foundation

final class CategoriesHomeViewModel: ObservableObject {
    
    let categories = PredefinedObjectManager.shared.allPredefinedCategory
    let filter: Filter = .shared
    
    @Published var selectedCategory: PredefinedCategory? = nil
    
    @Published var searchText: String = ""
}

extension CategoriesHomeViewModel {
    
    var dataWithFilterChoosen: Bool {
        if !filter.automation && !filter.total {
            if categories.map({ $0.expensesTransactionsAmountForSelectedDate(filter: filter) }).reduce(0, +) > 0 { return true } else { return false }
        } else if filter.automation && !filter.total {
            if categories.map({ $0.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date) }).reduce(0, +) > 0 { return true } else { return false }
        } else if !filter.automation && filter.total {
            if categories.map({ $0.amountTotalOfExpenses }).reduce(0, +) > 0 { return true } else { return false }
        } else if filter.automation && filter.total {
            if categories.map({ $0.amountTotalOfExpensesAutomations }).reduce(0, +) > 0 { return true } else { return false }
        }
        return false
    }
    
    var searchResults: [PredefinedCategory] {
        let predefCategories = categories
        
        if searchText.isEmpty {
            return predefCategories.sorted { $0.title < $1.title }
        } else {
            let isCategoryEmpty: Bool = predefCategories.sorted { $0.title < $1.title }.filter { $0.title.localizedStandardContains(searchText) }.isEmpty
            
            if isCategoryEmpty {
                var subcategories: [PredefinedSubcategory] = []
                
                for category in predefCategories {
                    for subcategory in category.subcategories {
                        subcategories.append(subcategory)
                    }
                }
                
                let filterSubcategories = subcategories.filter { $0.title.localizedStandardContains(searchText) }
                
                var categories: [PredefinedCategory] = []
                for subcategory in filterSubcategories {
                    if !categories.contains(subcategory.category) {
                        categories.append(subcategory.category)
                    }
                }
                
                return categories.sorted { $0.title < $1.title }
            } else {
                return predefCategories.sorted { $0.title < $1.title }.filter { $0.title.localizedStandardContains(searchText) }
            }
        }
    }
    
}
