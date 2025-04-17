//
//  SavingsAccountDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum SavingsAccountDestination: AppDestinationProtocol {
    case list
    case detail(savingsAccount: AccountModel)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .list:
            SavingsAccountHomeView()
        case .detail(let savingsAccount):
            SavingsAccountDetailView(savingsAccount: savingsAccount)
        }
    }
}
