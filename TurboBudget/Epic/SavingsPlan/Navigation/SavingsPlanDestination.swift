//
//  SavingsPlanDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum SavingsPlanDestination: AppDestinationProtocol {
    case list
    case create
    case update(savingsPlan: SavingsPlanModel)
    case detail(savingsPlan: SavingsPlanModel)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .list:
            SavingsPlanListScreen()
        case .create:
            CreateSavingPlansScreen()
        case .update(let savingsPlan):
            CreateSavingPlansScreen(savingsPlan: savingsPlan)
        case .detail(let savingsPlan):
            SavingsPlanDetailScreen(savingsPlan: savingsPlan)
        }
    }
}
