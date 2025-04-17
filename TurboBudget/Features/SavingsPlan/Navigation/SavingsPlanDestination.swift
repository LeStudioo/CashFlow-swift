//
//  SavingsPlanDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum SavingsPlanDestination: AppDestinationProtocol {
    case home
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .home:
            SavingsPlansHomeView()
        }
    }
}
