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
    @ObservedObject var budget: BudgetModel
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading) {
            Text(budget.name)
                .font(.mediumCustom(size: 20))
            
            HStack(alignment: .center) {
                circleBudget(budget: budget)
                    .frame(width: 90, height: 90)
                    .padding(8)
                Spacer()
                VStack(spacing: 10) {
                    HStack {
                        Text("budget_cell_max".localized + " :")
                        Spacer()
                        Text(formatNumber(budget.amount))
                    }
                    .lineLimit(1)
                    .padding(8)
                    .background(Color.color2Apple)
                    .cornerRadius(12)
                    HStack {
                        Text("budget_cell_actual".localized + " :")
                        Spacer()
                        Text(formatNumber(budget.currentAmount))
                    }
                    .lineLimit(1)
                    .padding(8)
                    .background(Color.color2Apple)
                    .cornerRadius(12)
                    if budget.amount < budget.currentAmount {
                        HStack {
                            Text("budget_cell_overrun".localized + " :")
                            Spacer()
                            Text(formatNumber(budget.currentAmount - budget.amount))
                        }
                        .lineLimit(1)
                        .padding(8)
                        .background(Color.color2Apple)
                        .cornerRadius(12)
                    }
                }
                .font(Font.mediumText16())
                .padding(8)
            }
        }
        .foregroundStyle(Color(uiColor: .label))
        .padding()
        .background(Color.colorCell)
        .cornerRadius(15)
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
