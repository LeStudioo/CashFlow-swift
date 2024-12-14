//
//  DashboardChart.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import SwiftUI

struct DashboardChart: View {
    
    // Repository
    @EnvironmentObject private var transactionRepository: TransactionRepository
    
    var amountExpenses: Double {
        return transactionRepository.amountExpensesForSelectedMonth(month: .now)
    }
    var amountIncomes: Double {
        return transactionRepository.amountIncomesForSelectedMonth(month: .now)
    }
    var amountCashFlow: Double {
        return transactionRepository.amountCashFlowByMonth(month: .now)
    }
    var amountGainOrLoss: Double {
        return transactionRepository.amountGainOrLossByMonth(month: .now)
    }
    
    // MARK: -
    var body: some View {
        if amountExpenses != 0 {
            VStack(alignment: .leading) {
                Text(Date().formatted(.monthAndYear).capitalized)
                    .font(.semiBoldH3())
                    .padding(.leading, 8)
                
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        CustomRow(
                            text: "word_expenses".localized,
                            amount: amountExpenses.toCurrency()
                        )
                        CustomRow(
                            text: "word_incomes".localized,
                            amount: amountIncomes.toCurrency()
                        )
                    }
                    CustomRow(
                        text: "account_detail_cashflow".localized,
                        amount: amountCashFlow.toCurrency()
                    )
                }
            }
            .padding(8)
            .foregroundStyle(Color.text)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.background100)
            }
        }
    } // body
    
    @ViewBuilder
    private func CustomRow(text: String, amount: String) -> some View {
        HStack {
            Text(text)
            Spacer()
            Text(amount)
        }
        .font(.mediumSmall())
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.background200)
        }
    }
} // struct

// MARK: - Preview
#Preview {
    DashboardChart()
        .padding()
}
