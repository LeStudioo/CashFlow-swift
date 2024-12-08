//
//  DetailOfExpensesAndIncomesByMonth.swift
//  CashFlow
//
//  Created by KaayZenn on 25/09/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct DetailOfExpensesAndIncomesByMonth: View {
    
    //Builder
    var month: Date
    var amountOfExpenses: Double
    var amountOfIncomes: Double
    var isPinned: Bool = false

    //Environnement
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var store: PurchasesManager

    //MARK: - Body
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(month.formatted(.monthAndYear).capitalized)
                    .font(.mediumCustom(size: 22))
                    .foregroundStyle(Color(uiColor: .label))
                
                if store.isCashFlowPro {
                    HStack {
                        if amountOfExpenses != 0 {
                            Text("word_expenses".localized + " : " + amountOfExpenses.currency)
                                .lineLimit(1)
                        }
                        if amountOfExpenses != 0 && amountOfIncomes != 0 {
                            Text("|")
                        }
                        if amountOfIncomes != 0 {
                            Text("word_incomes".localized + " : " + amountOfIncomes.currency)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                    .font(.semiBoldSmall())
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background {
            if isPinned {
                Rectangle().fill(Material.regular)
            } else {
                Color.clear
            }
        }
        .compositingGroup()
    }//END body
}//END struct

//MARK: - Preview
struct DetailOfExpensesAndIncomesByMonth_Previews: PreviewProvider {
    static var previews: some View {
        DetailOfExpensesAndIncomesByMonth(
            month: .now,
            amountOfExpenses: 200,
            amountOfIncomes: 10
        )
    }
}
