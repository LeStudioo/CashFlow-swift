//
//  BudgetsDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum BudgetsDestination: AppDestinationProtocol {
    case list
    case create
    case transactions(subcategory: SubcategoryModel)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .list:
            BudgetsListScreen()
        case .create:
            CreateBudgetScreen()
        case .transactions(let subcategory):
            BudgetsTransactionsListScreen(subcategory: subcategory)
        }
    }
}
