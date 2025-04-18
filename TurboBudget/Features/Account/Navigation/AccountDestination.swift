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
            CreateAccountView(type: .classic)
        case .update(let account):
            CreateAccountView(type: .classic, account: account)
        case .dashboard:
            AccountDashboardView()
        case .statistics:
            AccountStatisticsView()
        }
    }
}
