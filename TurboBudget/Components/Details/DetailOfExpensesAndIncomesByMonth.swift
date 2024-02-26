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

    //Custom type

    //Environnement
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var store: Store
    
    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool

	//Enum
	
	//Computed var

    //MARK: - Body
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(HelperManager().formattedDateWithMonthYear(date: month))
                    .font(.mediumCustom(size: 22))
                if store.isLifetimeActive {
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
                    .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                    .font(.semiBoldSmall())
                }
            }
            Spacer()
        }
        .padding([.horizontal, .top])
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
