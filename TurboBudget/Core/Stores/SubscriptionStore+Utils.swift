//
//  SubscriptionRepositoryUtils.swift
//  CashFlow
//
//  Created by Theo Sementa on 02/12/2024.
//

import Foundation

extension SubscriptionStore {
    
    func sortSubscriptionsByDate() {
        self.subscriptions.sort { $0.frequencyDate < $1.frequencyDate }
    }
    
}

extension SubscriptionStore {
    
    func amountExpensesByMonth(month: Date) -> Double {
        return self.subscriptions
            .filter { Calendar.current.isDate($0.frequencyDate, equalTo: month, toGranularity: .month) && $0.type == .expense }
            .map({ $0.amount })
            .reduce(0, +)
    }
    
    func amountIncomesByMonth(month: Date) -> Double {
        return self.subscriptions
            .filter { Calendar.current.isDate($0.frequencyDate, equalTo: month, toGranularity: .month) && $0.type == .income }
            .map({ $0.amount })
            .reduce(0, +)
    }
    
}
