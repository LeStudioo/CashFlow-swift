//
//  BudgetRow.swift
//  CashFlow
//
//  Created by KaayZenn on 04/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct BudgetRow: View {

    //Custom type
    @ObservedObject var budget: BudgetModel

    //State or Binding Int, Float and Double
    @State var valueForCircle: Double = 0

    //State or Binding Date
    @Binding var selectedDate: Date
    
    // Computed
    var actualAmount: Double {
        // TODO: - refacto
//        return budget.actualAmountForMonth(month: selectedDate)
        return 100
    }
    
    //MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            Text(budget.name)
                .font(.mediumCustom(size: 20))
            
            HStack(alignment: .center) {
                circleBudget(budget: budget, value: valueForCircle)
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
                        Text(formatNumber(actualAmount))
                    }
                    .lineLimit(1)
                    .padding(8)
                    .background(Color.color2Apple)
                    .cornerRadius(12)
                    if budget.amount < actualAmount {
                        HStack {
                            Text("budget_cell_overrun".localized + " :")
                            Spacer()
                            Text(formatNumber(actualAmount - budget.amount))
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring()) { valueForCircle = actualAmount / budget.amount }
            }
        }
        .onChange(of: budget) { _ in // TODO: A VOIR
            withAnimation(.spring()) { valueForCircle = actualAmount / budget.amount }
        }
    }//END body
    
    //MARK: ViewBuilder
    @ViewBuilder
    func circleBudget(budget: BudgetModel, value: Double) -> some View {
        let textInCircle: Double = actualAmount / budget.amount * 10
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 20))
                .foregroundStyle(budget.color.opacity(0.5))
            Circle()
                .trim(from: 0, to: value)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundStyle(budget.color)
                .rotationEffect(.degrees(-90))
            Text(String(format: "%.1f", textInCircle * 10) + "%")
                .font(.semiBoldSmall())
                .foregroundStyle(Color(uiColor: .label))
        }
    }
} // End struct

// MARK: - Preview
//struct BudgetCellView_Previews: PreviewProvider {
//    
//    @State static var datePreview: Date = Date()
//    
//    static var previews: some View {
//        Group {
//            BudgetRow(budget: Budget.preview1, selectedDate: $datePreview)
//            BudgetRow(budget: Budget.preview2, selectedDate: $datePreview)
//        }
//    }
//}
