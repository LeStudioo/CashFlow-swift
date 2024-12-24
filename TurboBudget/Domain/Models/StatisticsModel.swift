//
//  StatisticsModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/12/2024.
//

import Foundation

struct StatisticsModel: Codable {
    let week: WeeklyStatistics?
    let month: MonthlyStatistics?
    let year: YearlyStatistics?
}

// MARK: - Weekly
struct WeeklyStatistics: Codable {
    let expense: ExpenseWeeklyStatistics?
    let income: IncomeWeeklyStatistics?
}

struct ExpenseWeeklyStatistics: Codable {
    let thisWeek: Double?
    let lastWeek: Double?
}

struct IncomeWeeklyStatistics: Codable {
    let thisWeek: Double?
    let lastWeek: Double?
}

// MARK: - Monthly
struct MonthlyStatistics: Codable {
    let expense: ExpenseMonthlyStatistics?
    let income: IncomeMonthlyStatistics?
}

struct ExpenseMonthlyStatistics: Codable {
    let thisMonth: Double?
    let lastMonth: Double?
}

struct IncomeMonthlyStatistics: Codable {
    let thisMonth: Double?
    let lastMonth: Double?
}

// MARK: - Yearly
struct YearlyStatistics: Codable {
    let expense: ExpenseYearlyStatistics?
    let income: IncomeYearlyStatistics?
}

struct ExpenseYearlyStatistics: Codable {
    let thisYear: Double?
    let lastYear: Double?
}

struct IncomeYearlyStatistics: Codable {
    let thisYear: Double?
    let lastYear: Double?
}
