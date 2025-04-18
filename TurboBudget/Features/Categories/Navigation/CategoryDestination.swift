//
//  CategoryDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum CategoryDestination: AppDestinationProtocol, Equatable, Hashable {
    case list
    case transactions(category: CategoryModel, selectedDate: Date)
    case select(selectedCategory: Binding<CategoryModel?>, selectedSubcategory: Binding<SubcategoryModel?>)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .list:
            CategoryHomeView()
        case .transactions(let category, let selectedDate):
            CategoryTransactionsView(category: category, selectedDate: selectedDate)
        case .select(let selectedCategory, let selectedSubcategory):
            SelectCategoryView(selectedCategory: selectedCategory, selectedSubcategory: selectedSubcategory)
        }
    }
    
    static func == (lhs: CategoryDestination, rhs: CategoryDestination) -> Bool {
        switch (lhs, rhs) {
        case (.list, .list):
            return true
        case (.transactions(let lhsCategory, let lhsDate), .transactions(let rhsCategory, let rhsDate)):
            return lhsCategory == rhsCategory && lhsDate == rhsDate
        case (.select(let lhsCategory, let lhsSubcategory), .select(let rhsCategory, let rhsSubcategory)):
            // Compare the wrapped values instead of the bindings
            return lhsCategory.wrappedValue == rhsCategory.wrappedValue &&
                   lhsSubcategory.wrappedValue == rhsSubcategory.wrappedValue
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .list:
            hasher.combine(0)
        case .transactions(let category, let date):
            hasher.combine(1)
            hasher.combine(category)
            hasher.combine(date)
        case .select(let category, let subcategory):
            hasher.combine(2)
            hasher.combine(category.wrappedValue)
            hasher.combine(subcategory.wrappedValue)
        }
    }
}
