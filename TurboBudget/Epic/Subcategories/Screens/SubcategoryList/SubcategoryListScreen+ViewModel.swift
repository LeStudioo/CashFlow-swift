//
//  SubcategoryHomeViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 04/07/2024.
//

import Foundation

extension SubcategoryListScreen {
    
    final class ViewModel: ObservableObject {
        @Published var selectedSubcategory: SubcategoryModel?        
        @Published var searchText: String = ""
    }
    
}

extension SubcategoryListScreen.ViewModel {
    
    func isDisplayChart(category: CategoryModel) -> Bool {
        let transactionStore: TransactionStore = .shared
        
        if category.isToCategorized {
            return false
        } else {
            return transactionStore.getExpenses(for: category, in: .now).isNotEmpty
        }
    }
    
}
