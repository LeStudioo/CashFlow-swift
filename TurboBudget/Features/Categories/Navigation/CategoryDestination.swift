//
//  CategoryDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum CategoryDestination: AppDestinationProtocol {
    case list
    case transactions(category: CategoryModel, selectedDate: Date)
//    case select(selectedCategory: Binding<CategoryModel?>, selectedSubcategory: Binding<SubcategoryModel?>)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .list:
            CategoryHomeView()
        case .transactions(let category, let selectedDate):
            CategoryTransactionsView(category: category, selectedDate: selectedDate)
//        case .select(let selectedCategory, let selectedSubcategory):
//            SelectCategoryView(selectedCategory: selectedCategory, selectedSubcategory: selectedSubcategory)
        }
    }
}
