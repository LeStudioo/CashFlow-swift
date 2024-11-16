//
//  ContributionMock.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/11/2024.
//

import Foundation

extension ContributionModel {
    
    static let mockContribution: ContributionModel = .init(
        amount: 100,
        date: Date().toISO()
    )
    
}
