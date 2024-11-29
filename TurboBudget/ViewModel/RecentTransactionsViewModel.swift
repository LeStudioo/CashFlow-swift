//
//  RecentTransactionsViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 16/03/2024.
//

import Foundation
import SwiftUI

class RecentTransactionsViewModel: ObservableObject {
    
    // Custom
    @ObservedObject var filter = FilterManager.shared
    
    // String variables
    @Published var searchText: String = ""
    
    func searchResults() -> [TransactionModel] {
        let filteredTransactions = TransactionRepository.shared.transactions.filter { transaction in
            let byMonthCondition = !filter.byMonth || transaction.date <= filter.date
            let onlyIncomesCondition = !filter.onlyIncomes || transaction.type == .income
            let onlyExpensesCondition = !filter.onlyExpenses || transaction.type == .expense
            return byMonthCondition && onlyIncomesCondition && onlyExpensesCondition
        }

        switch filter.sortBy {
        case .date:
            return filteredTransactions.sorted { $0.date > $1.date }
        case .ascendingOrder:
            return filteredTransactions.sorted { $0.amount ?? 0 > $1.amount ?? 0 }
        case .descendingOrder:
            return filteredTransactions.sorted { $0.amount ?? 0 < $1.amount ?? 0 }
        case .alphabetic:
            return filteredTransactions.sorted { $0.name ?? "" < $1.name ?? "" }
        }
    }
}
