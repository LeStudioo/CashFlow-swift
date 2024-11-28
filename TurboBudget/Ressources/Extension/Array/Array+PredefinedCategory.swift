//
//  Array+PredefinedCategory.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import Foundation

extension Array where Element == CategoryModel {
    
    func searchFor(_ searchText: String) -> [CategoryModel] {
        let categories = CategoryRepository.shared.categories
        
        if searchText.isEmpty {
            return categories.sorted { $0.name < $1.name }
        } else { //Searching
            let filteredCategories = categories
                .filter {
                    $0.name.localizedStandardContains(searchText)
                    || (($0.subcategories ?? []).contains { $0.name.localizedStandardContains(searchText) })
                }
                .sorted { $0.name < $1.name }
            
            return filteredCategories
        }
    }
    
}
