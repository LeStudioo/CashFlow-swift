//
//  BudgetRow.swift
//  CashFlow
//
//  Created by KaayZenn on 04/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct BudgetRow: View {

    // Builder
    var budget: BudgetModel
    
    @EnvironmentObject var budgetStore: BudgetStore
    
    var currentBudget: BudgetModel {
        return budgetStore.budgets.first { $0.id == budget.id } ?? budget
    }
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading) {
            Text(currentBudget.name)
                .font(.mediumCustom(size: 20))
            
            HStack(alignment: .center) {
                circleBudget(budget: currentBudget)
                    .frame(width: 90, height: 90)
                    .padding(8)
                Spacer()
                VStack(spacing: 10) {
                    HStack {
                        Text("budget_cell_max".localized + " :")
                        Spacer()
                        Text(formatNumber(currentBudget.amount))
                    }
                    .lineLimit(1)
                    .padding(8)
                    .background(Color.background200)
                    .cornerRadius(12)
                    HStack {
                        Text("budget_cell_actual".localized + " :")
                        Spacer()
                        Text(formatNumber(currentBudget.currentAmount))
                    }
                    .lineLimit(1)
                    .padding(8)
                    .background(Color.background200)
                    .cornerRadius(12)
                    if currentBudget.amount < currentBudget.currentAmount {
                        HStack {
                            Text("budget_cell_overrun".localized + " :")
                            Spacer()
                            Text(formatNumber(currentBudget.currentAmount - currentBudget.amount))
                        }
                        .lineLimit(1)
                        .padding(8)
                        .background(Color.background200)
                        .cornerRadius(12)
                    }
                }
                .font(Font.mediumText16())
                .padding(8)
            }
        }
        .foregroundStyle(Color.text)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.background100)
        }
    } // body
    
    // MARK: ViewBuilder
    @ViewBuilder
    func circleBudget(budget: BudgetModel) -> some View {
        let textInCircle: Double = budget.currentAmount / budget.amount * 10
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 20))
                .foregroundStyle(budget.color.opacity(0.5))
            Circle()
                .trim(from: 0, to: budget.currentAmount / budget.amount)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundStyle(budget.color)
                .rotationEffect(.degrees(-90))
            Text(String(format: "%.1f", textInCircle * 10) + "%")
                .font(.semiBoldSmall())
                .foregroundStyle(Color(uiColor: .label))
        }
    }
} // struct

// MARK: - Preview
#Preview {
    BudgetRow(budget: .mock)
}
