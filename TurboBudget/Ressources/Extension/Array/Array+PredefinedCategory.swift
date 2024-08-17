//
//  Array+PredefinedCategory.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import Foundation

extension Array where Element == PredefinedCategory {
    
    func searchFor(_ searchText: String) -> [PredefinedCategory] {
        let categories = PredefinedCategory.allCases
        
        if searchText.isEmpty {
            return categories.sorted { $0.title < $1.title }
        } else { //Searching
            let categoryFilterByTitle: [PredefinedCategory] = categories
                .filter { $0.title.localizedStandardContains(searchText) }
                .sorted { $0.title < $1.title }
            
            if categoryFilterByTitle.isEmpty {
                let subcategories: [PredefinedSubcategory] = categories.flatMap(\.subcategories)
                
                let filterSubcategories = subcategories
                    .filter { $0.title.localizedStandardContains(searchText) }

                var categories: [PredefinedCategory] = []
                for subcategory in filterSubcategories {
                    if let category = PredefinedCategory.findByID(subcategory.category.id) {
                        categories.append(category)
                    }
                }
                
                return categories
                    .sorted { $0.title < $1.title }
            } else {
                return categoryFilterByTitle
            }
        }
    }
    
}
