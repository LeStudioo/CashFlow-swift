//
//  AccountDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum AccountDestination: AppDestinationProtocol {
    case create(type: AccountType, account: AccountModel? = nil)
    case dashboard
    case statistics
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .create(let type, let account):
            CreateAccountView(type: type, account: account)
        case .dashboard:
            AccountDashboardView()
        case .statistics:
            AccountStatisticsView()
        }
    }
}
