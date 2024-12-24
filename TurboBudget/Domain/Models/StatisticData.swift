//
//  StatisticData.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/12/2024.
//

import Foundation

struct StatisticData: Identifiable {
    let id: UUID = UUID()
    let text: String
    let value: Double
}
