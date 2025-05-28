//
//  TipsDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import SwiftUICore
import NavigationKit

enum TipsDestination: AppDestinationProtocol {
    case applePayShortcut
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .applePayShortcut:
            TipApplePayShortcutScreen()
        }
    }
}
