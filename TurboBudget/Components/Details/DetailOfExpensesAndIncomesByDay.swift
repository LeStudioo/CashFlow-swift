//
//  DetailOfExpensesAndIncomesByDay.swift
//  CashFlow
//
//  Created by KaayZenn on 26/09/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct DetailOfExpensesAndIncomesByDay: View {

    //Builder
    var day: Date
    var amountOfExpenses: Double
    var amountOfIncomes: Double

    //Custom type
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared

    //Environnement
    @Environment(\.colorScheme) private var colorScheme

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool

	//Enum
	
	//Computed var

    //MARK: - Body
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(HelperManager().formattedDateWithDayMonthYear(date: day))
                    .font(.mediumCustom(size: 22))
                if userDefaultsManager.isCashFlowProEnable {
                    HStack {
                        if amountOfExpenses != 0 {
                            Text(NSLocalizedString("word_expenses", comment: "") + " : " + amountOfExpenses.currency)
                                .lineLimit(1)
                        }
                        if amountOfExpenses != 0 && amountOfIncomes != 0 {
                            Text("|")
                        }
                        if amountOfIncomes != 0 {
                            Text(NSLocalizedString("word_incomes", comment: "") + " : " + amountOfIncomes.currency)
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

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct DetailOfExpensesAndIncomesByDay_Previews: PreviewProvider {
    static var previews: some View {
        DetailOfExpensesAndIncomesByDay(
            day: Date(),
            amountOfExpenses: 200,
            amountOfIncomes: 100
        )
    }
}
