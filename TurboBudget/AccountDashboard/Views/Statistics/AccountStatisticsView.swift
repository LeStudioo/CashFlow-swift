//
//  AccountStatisticsView.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/12/2024.
//

import SwiftUI

struct AccountStatisticsView: View {
    
    @EnvironmentObject private var accountRepository: AccountRepository
    
    // MARK: -
    var body: some View {
        ScrollView {
            if let stats = accountRepository.stats {
                VStack(spacing: 24) {
                    if let week = stats.week, let year = stats.year {
                        StatisticsSection(title: Word.Temporality.week) {
                            VStack(spacing: 20) {
                                StatisticsCell(
                                    title: "TBL Total dépensé",
                                    statistics: [
                                        .init(text: "TBL Cette semaine", value: week.expense?.thisWeek ?? 0),
                                        .init(text: "TBL La semaine dernière", value: week.expense?.lastWeek ?? 0),
                                    ]
                                )
                                StatisticsCell(
                                    title: "TBL Total gagné",
                                    statistics: [
                                        .init(text: "TBL Cette semaine", value: week.income?.thisWeek ?? 0),
                                        .init(text: "TBL La semaine dernière", value: week.income?.lastWeek ?? 0),
                                    ]
                                )
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.background100)
                            }
                            
                            VStack(spacing: 20) {
                                StatisticsCell(
                                    title: "TBL Dépensé par semaine en moyenne",
                                    statistics: [
                                        .init(text: "TBL Cette année", value: ((year.expense?.thisYear ?? 0) / Double(Date().week))),
                                        .init(text: "TBL L'année dernière", value: ((year.expense?.lastYear ?? 0) / 52)),
                                    ]
                                )
                                StatisticsCell(
                                    title: "TBL Revenu par semaine en moyenne",
                                    statistics: [
                                        .init(text: "TBL Cette année", value: ((year.income?.thisYear ?? 0) / Double(Date().week))),
                                        .init(text: "TBL L'année dernière", value: ((year.income?.lastYear ?? 0) / 52)),
                                    ]
                                )
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.background100)
                            }
                        }
                        
                        if let month = stats.month {
                            StatisticsSection(title: Word.Temporality.month) {
                                VStack(spacing: 20) {
                                    StatisticsCell(
                                        title: "TBL Total dépensé",
                                        statistics: [
                                            .init(text: "TBL Ce mois-ci", value: month.expense?.thisMonth ?? 0),
                                            .init(text: "TBL Le mois dernier", value: month.expense?.lastMonth ?? 0),
                                        ]
                                    )
                                    StatisticsCell(
                                        title: "TBL Total gagné",
                                        statistics: [
                                            .init(text: "TBL Ce mois-ci", value: month.income?.thisMonth ?? 0),
                                            .init(text: "TBL Le mois dernier", value: month.income?.lastMonth ?? 0),
                                        ]
                                    )
                                }
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.background100)
                                }
                                
                                VStack(spacing: 20) {
                                    StatisticsCell(
                                        title: "TBL Dépensé par mois en moyenne",
                                        statistics: [
                                            .init(text: "TBL Ce mois-ci", value: ((year.expense?.thisYear ?? 0) / Double(Date().month))),
                                            .init(text: "TBL L'année dernière", value: ((year.expense?.lastYear ?? 0) / 12)),
                                        ]
                                    )
                                    StatisticsCell(
                                        title: "TBL Revenu par mois en moyenne",
                                        statistics: [
                                            .init(text: "TBL Ce mois-ci", value: ((year.income?.thisYear ?? 0) / Double(Date().month))),
                                            .init(text: "TBL L'année dernière", value: ((year.income?.lastYear ?? 0) / 12))
                                        ]
                                    )
                                }
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.background100)
                                }
                            }
                            
                            StatisticsSection(title: Word.Temporality.year) {
                                VStack(spacing: 20) {
                                    StatisticsCell(
                                        title: "TBL Total dépensé",
                                        statistics: [
                                            .init(text: "TBL Cette année", value: year.expense?.thisYear ?? 0),
                                            .init(text: "TBL L'année dernière", value: year.expense?.lastYear ?? 0),
                                        ]
                                    )
                                    StatisticsCell(
                                        title: "TBL Total gagné",
                                        statistics: [
                                            .init(text: "TBL Cette année", value: year.income?.thisYear ?? 0),
                                            .init(text: "TBL L'année dernièr", value: year.income?.lastYear ?? 0),
                                        ]
                                    )
                                }
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.background100)
                                }
                            }
                        }
                    }
                } // VStack
                .padding()
            }
        } // ScrollView
        .background(Color.background)
        .task {
            if let selectedAccount = accountRepository.selectedAccount, let accountID = selectedAccount.id {
                await accountRepository.fetchStats(accountID: accountID)
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    AccountStatisticsView()
        .environmentObject(AccountRepository())
}
