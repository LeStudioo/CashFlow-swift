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
                    if let week = stats.week {
                        StatisticsSection(title: Word.Temporality.week) {
                            StatisticsCell(
                                title: "TBL Dépenses et Revenus totaux",
                                statistics: [
                                    .init(text: "TBL Total expense", value: week.totalExpense ?? 0),
                                    .init(text: "TBL Total income", value: week.totalIncome ?? 0),
                                    .init(text: "TBL Average expense", value: week.averageExpense ?? 0),
                                    .init(text: "TBL Average income", value: week.averageIncome ?? 0),
                                ]
                            )
                        }
                    }
                    
                    
                    if let month = stats.month {
                        StatisticsSection(title: Word.Temporality.month) {
                            StatisticsCell(
                                title: "TBL Dépenses et Revenus totaux",
                                statistics: [
                                    .init(text: "TBL Total expense", value: month.totalExpense ?? 0),
                                    .init(text: "TBL Total income", value: month.totalIncome ?? 0),
                                    .init(text: "TBL Average expense", value: month.averageExpense ?? 0),
                                    .init(text: "TBL Average income", value: month.averageIncome ?? 0),
                                ]
                            )
                        }
                    }
                    
                    if let year = stats.year {
                        StatisticsSection(title: Word.Temporality.year) {
                            StatisticsCell(
                                title: "TBL Dépenses et Revenus totaux",
                                statistics: [
                                    .init(text: "TBL Total expense", value: year.totalExpense ?? 0),
                                    .init(text: "TBL Total income", value: year.totalIncome ?? 0),
                                    .init(text: "TBL Average expense", value: year.averageExpense ?? 0),
                                    .init(text: "TBL Average income", value: year.averageIncome ?? 0),
                                ]
                            )
                        }
                    }
                }
                .padding()
            }
        } // ScrollView
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
}
