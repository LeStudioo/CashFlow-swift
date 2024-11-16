//
//  SavingsPlanMock.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/11/2024.
//

import Foundation

extension SavingsPlanModel {
    
    static let mockClassicSavingsPlan: SavingsPlanModel = .init(
        id: 1,
        name: "Mock Savings Plan",
        emoji: "🤑",
        startDate: Date().toISO(),
        currentAmount: 200,
        goalAmount: 2000
    )
    
}
