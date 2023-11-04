//
//  CellBudgetView.swift
//  CashFlow
//
//  Created by KaayZenn on 04/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct CellBudgetView: View {

    //Custom type
    var budget: Budget

    //Environnements

    //State or Binding String

    //State or Binding Int, Float and Double
    @State var valueForCircle: Double = 0

    //State or Binding Bool
    
    //State or Binding Date
    @Binding var selectedDate: Date

	//Enum
	
	//Computed var
    
    var actualAmount: Double { return budget.actualAmountForMonth(month: selectedDate) }

    //Binding update
    @Binding var update: Bool
    
    //MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            Text(budget.title)
                .lineLimit(1)
                .adaptText()
                .font(.mediumCustom(size: 20))
            
            HStack(alignment: .center) {
                circleBudget(budget: budget, value: valueForCircle)
                    .frame(width: 90, height: 90)
                    .padding(8)
                Spacer()
                VStack(spacing: 10) {
                    HStack {
                        Text(NSLocalizedString("budget_cell_max", comment: "") + " :")
                        Spacer()
                        Text(formatNumber(budget.amount))
                    }
                    .lineLimit(1)
                    .padding(8)
                    .background(Color.color2Apple)
                    .cornerRadius(12)
                    HStack {
                        Text(NSLocalizedString("budget_cell_actual", comment: "") + " :")
                        Spacer()
                        Text(formatNumber(actualAmount))
                    }
                    .lineLimit(1)
                    .padding(8)
                    .background(Color.color2Apple)
                    .cornerRadius(12)
                    if budget.amount < actualAmount {
                        HStack {
                            Text(NSLocalizedString("budget_cell_overrun", comment: "") + " :")
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
        .foregroundColor(.colorLabel)
        .padding()
        .background(Color.colorCell)
        .cornerRadius(15)
        .padding(update ? 0 : 0)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring()) { valueForCircle = actualAmount / budget.amount }
            }
        }
        .onChange(of: update) { _ in
            withAnimation(.spring()) { valueForCircle = actualAmount / budget.amount }
        }
    }//END body
    
    //MARK: ViewBuilder
    @ViewBuilder
    func circleBudget(budget: Budget, value: Double) -> some View {
        let textInCircle: Double = actualAmount / budget.amount * 10
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 20))
                .foregroundColor(budget.color.opacity(0.5))
            Circle()
                .trim(from: 0, to: value)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundColor(budget.color)
                .rotationEffect(.degrees(-90))
            Text(String(format: "%.1f", textInCircle * 10) + "%")
                .font(.semiBoldSmall())
                .foregroundColor(.colorLabel)
        }
        .padding(update ? 0 : 0)
    }
}//END struct

//MARK: - Preview
struct BudgetCellView_Previews: PreviewProvider {
    
    @State static var datePreview: Date = Date()
    @State static var update: Bool = false
    
    static var previews: some View {
        Group {
            CellBudgetView(budget: previewBudget1(), selectedDate: $datePreview, update: $update)
            CellBudgetView(budget: previewBudget2(), selectedDate: $datePreview, update: $update)
        }
        
    }
}
