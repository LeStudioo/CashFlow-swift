//
//  BudgetRowView.swift
//  CashFlow
//
//  Created by KaayZenn on 04/08/2023.
//
// Localizations 01/10/2023

import SwiftUI
import TheoKit
import DesignSystemModule
import CoreModule

struct BudgetRowView: View {
    
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
                let value = budget.currentAmount / budget.amount
                ProgressCircle(
                    value: value,
                    percentage: value * 10,
                    color: budget.color
                )
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
                    .background(Color.Background.bg200)
                    .cornerRadius(12)
                    HStack {
                        Text("budget_cell_actual".localized + " :")
                        Spacer()
                        Text(formatNumber(currentBudget.currentAmount))
                    }
                    .lineLimit(1)
                    .padding(8)
                    .background(Color.Background.bg200)
                    .cornerRadius(12)
                    if currentBudget.amount < currentBudget.currentAmount {
                        HStack {
                            Text("budget_cell_overrun".localized + " :")
                            Spacer()
                            Text(formatNumber(currentBudget.currentAmount - currentBudget.amount))
                        }
                        .lineLimit(1)
                        .padding(8)
                        .background(Color.Background.bg200)
                        .cornerRadius(12)
                    }
                }
                .font(Font.mediumText16())
                .padding(8)
            }
        }
        .foregroundStyle(Color.label)
        .padding()
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: CornerRadius.standard,
            lineWidth: 1,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
    } // body
} // struct

// MARK: - Preview
#Preview {
    BudgetRowView(budget: .mock)
}
