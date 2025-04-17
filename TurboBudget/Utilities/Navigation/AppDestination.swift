//
//  AppDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum AppDestination: AppDestinationProtocol {
    case savingsPlan(SavingsPlanDestination)
    case settings(SettingsDestination)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .savingsPlan(let savingsPlanDestination):
            savingsPlanDestination.body(route: route)
        case .settings(let settingsDestination):
            settingsDestination.body(route: route)
        }
    }
}
