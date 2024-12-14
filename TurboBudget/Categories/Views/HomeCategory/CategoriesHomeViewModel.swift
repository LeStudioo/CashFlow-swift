//
//  CategoriesHomeViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 04/07/2024.
//

import Foundation

final class CategoriesHomeViewModel: ObservableObject {
    
    let categories = CategoryRepository.shared.categories
    let filter: Filter = .shared
    
    @Published var selectedCategory: CategoryModel? = nil
    
    @Published var searchText: String = ""
}

extension CategoriesHomeViewModel {
    
    var categoriesFiltered: [CategoryModel] {
        return categories.searchFor(searchText)
    }
        
}
