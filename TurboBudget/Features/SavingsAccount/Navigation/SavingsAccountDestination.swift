//
//  SavingsAccountDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum SavingsAccountDestination: AppDestinationProtocol {
    case create
    case update(savingsAccount: AccountModel)
    case list
    case detail(savingsAccount: AccountModel)
    case createTransaction(savingsAccount: AccountModel, transaction: TransactionModel? = nil)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .create:
            CreateAccountView(type: .savings)
        case .update(let account):
            CreateAccountView(type: .savings, account: account)
        case .list:
            SavingsAccountHomeView()
        case .detail(let savingsAccount):
            SavingsAccountDetailView(savingsAccount: savingsAccount)
        case .createTransaction(let savingsAccount, let transaction):
            CreateTransactionForSavingsAccountView(savingsAccount: savingsAccount, transaction: transaction)
        }
    }
}
