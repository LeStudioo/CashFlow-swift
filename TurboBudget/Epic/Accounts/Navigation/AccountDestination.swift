//
//  AccountDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum AccountDestination: AppDestinationProtocol {
    case create
    case update(account: AccountModel)
    case dashboard
    case statistics
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .create:
            AccountAddScreen(type: .classic)
        case .update(let account):
            AccountAddScreen(type: .classic, account: account)
        case .dashboard:
            AccountDashboardScreen()
        case .statistics:
            AccountStatisticsScreen()
        }
    }
}
