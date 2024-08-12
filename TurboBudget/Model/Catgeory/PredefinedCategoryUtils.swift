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
        for category in self.allCases {
            if category.transactions.count != 0 {
                array.append(category)
            }
        }
        return array
            .sorted { $0.title < $1.title }
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
