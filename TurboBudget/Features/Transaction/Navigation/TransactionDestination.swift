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
    case create(transaction: TransactionModel? = nil)
    case detail(transaction: TransactionModel)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .list:
            TransactionsView()
        case .specificList(let month, let type):
            TransactionsForMonthView(selectedDate: month, type: type)
        case .create(let transaction):
            CreateTransactionView(transaction: transaction)
        case .detail(let transaction):
            TransactionDetailView(transaction: transaction)
        }
    }
}
