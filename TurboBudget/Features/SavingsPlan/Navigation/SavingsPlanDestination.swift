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
    case create(savingsPlan: SavingsPlanModel? = nil)
    case detail(savingsPlan: SavingsPlanModel)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .list:
            SavingsPlansHomeView()
        case .create(let savingsPlan):
            CreateSavingPlansView(savingsPlan: savingsPlan)
        case .detail(let savingsPlan):
            SavingsPlanDetailView(savingsPlan: savingsPlan)
        }
    }
}
