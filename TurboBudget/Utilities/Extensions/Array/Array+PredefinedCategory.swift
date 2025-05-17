//
//  Array+PredefinedCategory.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import Foundation

extension Array where Element == CategoryModel {
    
    func searchFor(_ searchText: String) -> [CategoryModel] {
        let categories = CategoryStore.shared.categories
        
        guard let income = categories.filter({ $0.isIncome }).first else { return [] }
        guard let toCategorized = categories.filter({ $0.isToCategorized }).first else { return [] }
        let allCategories = [toCategorized, income] + categories
            .filter { !$0.isIncome && !$0.isToCategorized }
            .sorted { $0.name < $1.name }
        
        if searchText.isEmpty {
            return allCategories
        } else { // Searching
            let filteredCategories = allCategories
                .filter {
                    $0.name.localizedStandardContains(searchText)
                    || (($0.subcategories ?? []).contains { $0.name.localizedStandardContains(searchText) })
                }
            
            return filteredCategories
        }
    }
    
}
