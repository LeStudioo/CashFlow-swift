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
    
    func searchResults(account: Account) -> [Transaction] {
        let filteredTransactions = account.transactions.filter { transaction in
            let byMonthCondition = !filter.byMonth || transaction.date <= filter.date
            let onlyIncomesCondition = !filter.onlyIncomes || transaction.amount > 0
            let onlyExpensesCondition = !filter.onlyExpenses || transaction.amount < 0
            return byMonthCondition && onlyIncomesCondition && onlyExpensesCondition
        }

        switch filter.sortBy {
        case .date:
            return filteredTransactions.sorted { $0.date < $1.date }
        case .ascendingOrder:
            return filteredTransactions.sorted { $0.amount > $1.amount }
        case .descendingOrder:
            return filteredTransactions.sorted { $0.amount < $1.amount }
        case .alphabetic:
            return filteredTransactions.sorted { $0.title < $1.title }
        }
    }
    
//    var searchResults: [Transaction] {
//        if searchText.isEmpty {
//            if filterTransactions == .expenses {
//                if ascendingOrder {
//                    return account.transactions.filter { $0.amount < 0 }.sorted { $0.amount < $1.amount }.reversed()
//                } else {
//                    return account.transactions.filter { $0.amount < 0 }.sorted { $0.amount < $1.amount }
//                }
//            } else if filterTransactions == .incomes {
//                if ascendingOrder {
//                    return account.transactions.filter { $0.amount > 0 }.sorted { $0.amount > $1.amount }.reversed()
//                } else {
//                    return account.transactions.filter { $0.amount > 0 }.sorted { $0.amount > $1.amount }
//                }
//            } else if filterTransactions == .category {
//                return account.transactions.filter({ $0.date >= Date().startOfMonth && $0.date <= Date().endOfMonth })
//            } else {
//                return account.transactions
//            }
//        } else { //Searching
//            let transactionsFilterByTitle = account.transactions.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
//            let transactionsFilterByDate = account.transactions.filter { HelperManager().formattedDateWithMonthYear(date: $0.date).localizedCaseInsensitiveContains(searchText) }
//            
//            if transactionsFilterByTitle.isEmpty {
//                return transactionsFilterByDate
//            } else {
//                return transactionsFilterByTitle
//            }
//        }
//    }
}
