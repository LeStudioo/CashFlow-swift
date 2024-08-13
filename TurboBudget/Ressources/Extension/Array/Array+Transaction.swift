//
//  Array+Transaction.swift
//  CashFlow
//
//  Created by KaayZenn on 12/08/2024.
//

import Foundation

extension Array where Element == Transaction {
    
    // TODO: Faire avec ChatGPT
//    func searchFor(_ searchText: String) -> [Transaction] {
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
