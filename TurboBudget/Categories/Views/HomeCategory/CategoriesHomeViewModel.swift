//
//  CategoriesHomeViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 04/07/2024.
//

import Foundation

final class CategoriesHomeViewModel: ObservableObject {
    
    let categories = CategoryStore.shared.categories
    let filter: Filter = .shared
        
    @Published var searchText: String = ""
}

extension CategoriesHomeViewModel {
    
    var isChartDisplayed: Bool {
        let transactionStore: TransactionStore = .shared
        return transactionStore.getExpenses(in: .now).isEmpty && transactionStore.getIncomes(in: .now).isEmpty
    }
    
    var categoriesFiltered: [CategoryModel] {
        return categories.searchFor(searchText)
    }
        
}
