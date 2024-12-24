//
//  SubscriptionRepositoryUtils.swift
//  CashFlow
//
//  Created by Theo Sementa on 02/12/2024.
//

import Foundation

extension SubscriptionStore {
    
    func sortSubscriptionsByDate() {
        self.subscriptions.sort { $0.date < $1.date }
    }
    
}

extension SubscriptionStore {
    
    func amountExpensesByMonth(month: Date) -> Double {
        return self.subscriptions
            .filter { Calendar.current.isDate($0.date, equalTo: month, toGranularity: .month) && $0.type == .expense }
            .map({ $0.amount ?? 0 })
            .reduce(0, +)
    }
    
    func amountIncomesByMonth(month: Date) -> Double {
        return self.subscriptions
            .filter { Calendar.current.isDate($0.date, equalTo: month, toGranularity: .month) && $0.type == .income }
            .map({ $0.amount ?? 0 })
            .reduce(0, +)
    }
    
}
