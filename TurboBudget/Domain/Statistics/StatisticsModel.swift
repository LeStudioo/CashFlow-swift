//
//  StatisticsModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/12/2024.
//

import Foundation

struct StatisticsModel: Codable {
    let week: StatisticsByTemporalityModel?
    let month: StatisticsByTemporalityModel?
    let year: StatisticsByTemporalityModel?
}

struct StatisticsByTemporalityModel: Codable {
    let totalExpense: Double?
    let totalIncome: Double?
    let averageExpense: Double?
    let averageIncome: Double?
}
