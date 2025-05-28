//
//  SettingsDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum SettingsDestination: AppDestinationProtocol {
    case home
    case debug
    case general
    case security
    case appearance
    case display
    case account
    case subscription
    case credits
    case applePay
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .home:
            SettingsScreen()
        case .debug:
            SettingsDebugView()
        case .general:
            SettingsGeneralView()
        case .security:
            SettingsSecurityView()
        case .appearance:
            SettingsAppearenceView()
        case .display:
            SettingsDisplayView()
        case .account:
            SettingsAccountScreen()
        case .subscription:
            SettingsSubscriptionScreen()
        case .credits:
            SettingsCreditsView()
        case .applePay:
            SettingsApplePayView()
        }
    }
}
