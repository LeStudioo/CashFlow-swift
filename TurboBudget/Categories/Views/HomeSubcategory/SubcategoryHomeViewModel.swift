//
//  SubcategoryHomeViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 04/07/2024.
//

import Foundation

final class SubcategoryHomeViewModel: ObservableObject {
    @Published var selectedSubcategory: SubcategoryModel?
    @Published var filter: Filter = .shared
    
    @Published var searchText: String = ""
}

extension SubcategoryHomeViewModel {
    
    func isDisplayChart(category: CategoryModel) -> Bool {
        if category.isToCategorized {
            return false
        } else {
            return !category.currentMonthExpenses.isEmpty
        }
    }
    
}
