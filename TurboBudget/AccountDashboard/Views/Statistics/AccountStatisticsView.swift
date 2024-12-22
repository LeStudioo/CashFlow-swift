//
//  AccountStatisticsView.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/12/2024.
//

import SwiftUI

struct AccountStatisticsView: View {
    
    @EnvironmentObject private var accountRepository: AccountRepository
    
    @State private var withSavings: Bool = false
    
    // MARK: -
    var body: some View {
        ScrollView {
            if let stats = accountRepository.stats {
                VStack(spacing: 24) {
                    Toggle(isOn: $withSavings, label: {
                        Text(Word.Statistics.withSavings)
                    })
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.background100)
                    }
                    
                    if let week = stats.week, let year = stats.year {
                        StatisticsSection(title: Word.Temporality.week) {
                            StatisticsCell(
                                title: Word.Statistics.totalExpenses,
                                statistics: [
                                    .init(text: Word.Temporality.thisWeek, value: week.expense?.thisWeek ?? 0),
                                    .init(text: Word.Temporality.lastWeek, value: week.expense?.lastWeek ?? 0),
                                ]
                            )
                            StatisticsCell(
                                title: Word.Statistics.totalIncomes,
                                statistics: [
                                    .init(text: Word.Temporality.thisWeek, value: week.income?.thisWeek ?? 0),
                                    .init(text: Word.Temporality.lastWeek, value: week.income?.lastWeek ?? 0),
                                ]
                            )
                            
                            StatisticsCell(
                                title: Word.Statistics.totalExpensesByWeek,
                                statistics: [
                                    .init(text: Word.Temporality.thisYear, value: ((year.expense?.thisYear ?? 0) / Double(Date().week))),
                                    .init(text: Word.Temporality.lastYear, value: ((year.expense?.lastYear ?? 0) / 52)),
                                ]
                            )
                            StatisticsCell(
                                title: Word.Statistics.totalIncomesByWeek,
                                statistics: [
                                    .init(text: Word.Temporality.thisYear, value: ((year.income?.thisYear ?? 0) / Double(Date().week))),
                                    .init(text: Word.Temporality.lastYear, value: ((year.income?.lastYear ?? 0) / 52)),
                                ]
                            )
                        }
                        
                        if let month = stats.month {
                            StatisticsSection(title: Word.Temporality.month) {
                                StatisticsCell(
                                    title: Word.Statistics.totalExpenses,
                                    statistics: [
                                        .init(text: Word.Temporality.thisMonth, value: month.expense?.thisMonth ?? 0),
                                        .init(text: Word.Temporality.lastMonth, value: month.expense?.lastMonth ?? 0),
                                    ]
                                )
                                StatisticsCell(
                                    title: Word.Statistics.totalIncomes,
                                    statistics: [
                                        .init(text: Word.Temporality.thisMonth, value: month.income?.thisMonth ?? 0),
                                        .init(text: Word.Temporality.lastMonth, value: month.income?.lastMonth ?? 0),
                                    ]
                                )
                                
                                StatisticsCell(
                                    title: Word.Statistics.totalExpensesByMonth,
                                    statistics: [
                                        .init(text: Word.Temporality.thisYear, value: ((year.expense?.thisYear ?? 0) / Double(Date().month))),
                                        .init(text: Word.Temporality.lastYear, value: ((year.expense?.lastYear ?? 0) / 12)),
                                    ]
                                )
                                StatisticsCell(
                                    title: Word.Statistics.totalIncomesByMonth,
                                    statistics: [
                                        .init(text: Word.Temporality.thisYear, value: ((year.income?.thisYear ?? 0) / Double(Date().month))),
                                        .init(text: Word.Temporality.lastYear, value: ((year.income?.lastYear ?? 0) / 12))
                                    ]
                                )
                            }
                            
                            StatisticsSection(title: Word.Temporality.year) {
                                StatisticsCell(
                                    title: Word.Statistics.totalExpenses,
                                    statistics: [
                                        .init(text: Word.Temporality.thisYear, value: year.expense?.thisYear ?? 0),
                                        .init(text: Word.Temporality.lastYear, value: year.expense?.lastYear ?? 0),
                                    ]
                                )
                                StatisticsCell(
                                    title: Word.Statistics.totalIncomes,
                                    statistics: [
                                        .init(text: Word.Temporality.thisYear, value: year.income?.thisYear ?? 0),
                                        .init(text: Word.Temporality.lastYear, value: year.income?.lastYear ?? 0),
                                    ]
                                )
                            }
                        }
                    }
                } // VStack
                .padding()
            }
        } // ScrollView
        .background(Color.background)
        .scrollIndicators(.hidden)
        .navigationTitle(Word.Classic.statistics)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
        }
        .task {
            if let selectedAccount = accountRepository.selectedAccount, let accountID = selectedAccount.id {
                await accountRepository.fetchStats(accountID: accountID, withSavings: withSavings)
            }
        }
        .onChange(of: withSavings) { newValue in
            Task {
                if let selectedAccount = accountRepository.selectedAccount, let accountID = selectedAccount.id {
                    await accountRepository.fetchStats(accountID: accountID, withSavings: newValue)
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    AccountStatisticsView()
        .environmentObject(AccountRepository())
}
