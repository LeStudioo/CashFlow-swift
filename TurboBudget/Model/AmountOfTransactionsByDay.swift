//
//  AmountOfTransactionsByDay.swift
//  CashFlow
//
//  Created by KaayZenn on 25/07/2023.
//

import Foundation

public struct AmountOfTransactionsByDay: Hashable {
    var day: Date
    var amount: Double
}

extension AmountOfTransactionsByDay {
    static let mockToday = AmountOfTransactionsByDay(
        day: Date(),
        amount: 150.0
    )
    
    static let mockTomorrow = AmountOfTransactionsByDay(
        day: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
        amount: 200.5
    )
    
    static let mockYesterday = AmountOfTransactionsByDay(
        day: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        amount: 75.3
    )
    
    static let mockAll: [AmountOfTransactionsByDay] = [
        .mockYesterday,
        .mockToday,
        .mockTomorrow
    ]
}
