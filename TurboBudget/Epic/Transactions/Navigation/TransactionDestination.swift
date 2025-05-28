//
//  TransactionDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum TransactionDestination: AppDestinationProtocol {
    case list
    case specificList(month: Date, type: TransactionType)
    case create
    case update(transaction: TransactionModel)
    case detail(transaction: TransactionModel)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .list:
            TransactionsScreen()
        case .specificList(let month, let type):
            TransactionsForMonthScreen(selectedDate: month, type: type)
        case .create:
            CreateTransactionScreen()
        case .update(let transaction):
            CreateTransactionScreen(transaction: transaction)
        case .detail(let transaction):
            TransactionDetailScreen(transaction: transaction)
        }
    }
}
