//
//  Utils.swift
//  CustomPieChart
//
//  Created by KaayZenn on 11/08/2024.
//

import Foundation

extension PredefinedCategory {
    
    static var categoriesWithTransactions: [PredefinedCategory] {
        var array: [PredefinedCategory] = []
        let filterManager = FilterManager.shared
        
        for category in self.allCases {
            let transactionsFiltered = category.transactions
                .filter {
                    Calendar.current.isDate(
                        $0.date.withDefault,
                        equalTo: filterManager.date,
                        toGranularity: .month
                    )
                }
            if transactionsFiltered.count != 0 {
                array.append(category)
            }
        }
        
        return array
            .sorted { $0.title < $1.title }
    }
    
}

// MARK: - Chart
extension PredefinedCategory {
    
    static var categoriesSlices: [PieSliceData] {
        var array: [PieSliceData] = []
        
        for category in self.categoriesWithTransactions.filter({ $0.id != PredefinedCategory.PREDEFCAT0.id }) {
            array.append(
                .init(
                    categoryID: category.id,
                    iconName: category.icon,
                    value: category.transactionsFiltered.map(\.amount).reduce(0, -),
                    color: category.color
                )
            )
        }
        
        return array
    }
    
    var categorySlices: [PieSliceData] {
        var array: [PieSliceData] = []
        let filterManager = FilterManager.shared
        
        for subcategory in self.subcategories {
            let transactionsFiltered = subcategory.transactions
                .filter { Calendar.current.isDate($0.date.withDefault, equalTo: filterManager.date, toGranularity: .month) }
            
            let amount = transactionsFiltered
                .map(\.amount)
                .reduce(0, -)
            
            if amount != 0 {
                array.append(
                    .init(
                        categoryID: subcategory.category.id,
                        subcategoryID: subcategory.id,
                        iconName: subcategory.icon,
                        value: subcategory.transactionsFiltered.map(\.amount).reduce(0, -),
                        color: subcategory.category.color
                    )
                )
            }
        }
                
        return array
    }
    
}

extension PredefinedCategory {
    
    // Voir pour essayer de passer en throw pour ne pas retourner un optionnel
    static func findByID(_ id: String) -> PredefinedCategory? {
        for cat in PredefinedCategory.allCases {
            if cat.id == id { return cat }
        }
        return nil
    }
    
}
