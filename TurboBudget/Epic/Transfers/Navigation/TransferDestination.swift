//
//  TransferDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import SwiftUICore
import NavigationKit

enum TransferDestination: AppDestinationProtocol {
    case create(receiverAccount: AccountModel? = nil)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .create(let receiverAccount):
            TransferAddScreen(receiverAccount: receiverAccount)
        }
    }
}
