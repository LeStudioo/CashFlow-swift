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
                Text(HelperManager().formattedDateWithMonthYear(date: .now))
                    .font(.semiBoldH3())
                    .padding(.leading, 8)
                
                HStack(spacing: 16) {
                    PieChart(
                        slices: PredefinedCategory.categoriesSlices,
                        backgroundColor: Color.colorCell,
                        configuration: .init(
                            style: .category,
                            space: 0.2,
                            hole: 0.75,
                            isInteractive: false
                        )
                    )
                    .frame(height: 180)
                    
                    VStack {
                        CustomRow(
                            text: "word_expenses".localized,
                            amount: amountExpenses.currency
                        )
                        CustomRow(
                            text: "word_incomes".localized,
                            amount: amountIncomes.currency
                        )
                        CustomRow(
                            text: "account_detail_cashflow".localized,
                            amount: amountCashFlow.currency
                        )
//                        CustomRow(
//                            text: amountGainOrLoss > 0 ? "account_detail_gain" : "account_detail_loss".localized,
//                            amount: amountGainOrLoss.currency
//                        )
                    }
                }
            }
            .padding(8)
            .foregroundStyle(Color.label)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.colorCell)
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
                .fill(Color.componentInComponent)
        }
    }
} // struct

// MARK: - Preview
#Preview {
    DashboardChart()
        .padding()
}
