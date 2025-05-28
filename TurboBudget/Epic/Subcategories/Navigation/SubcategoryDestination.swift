//
//  SubcategoryDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum SubcategoryDestination: AppDestinationProtocol {
    case list(category: CategoryModel, selectedDate: Date)
    case transactions(subcategory: SubcategoryModel, selectedDate: Date)
 
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .list(let category, let selectedDate):
            SubcategoryListScreen(category: category, selectedDate: selectedDate)
        case .transactions(let subcategory, let selectedDate):
            SubcategoryTransactionsScreen(subcategory: subcategory, selectedDate: selectedDate)
        }
    }
    
}
