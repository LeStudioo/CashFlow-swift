//
//  AmountByDay.swift
//  CashFlow
//
//  Created by KaayZenn on 25/07/2023.
//

import Foundation

struct AmountByDay: Hashable, Identifiable {
    let id: UUID = UUID()
    var day: Date
    var amount: Double
}

extension AmountByDay {
    static let mockToday = AmountByDay(
        day: Date(),
        amount: 150.0
    )
    
    static let mockTomorrow = AmountByDay(
        day: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
        amount: 200.5
    )
    
    static let mockYesterday = AmountByDay(
        day: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        amount: 75.3
    )
    
    static let mockAll: [AmountByDay] = [
        .mockYesterday,
        .mockToday,
        .mockTomorrow
    ]
}
