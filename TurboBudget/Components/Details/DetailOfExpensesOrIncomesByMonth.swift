//
//  DetailOfExpensesOrIncomesByMonth.swift
//  CashFlow
//
//  Created by KaayZenn on 25/09/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct DetailOfExpensesOrIncomesByMonth: View {
    
    //Builder
    @Binding var filterTransactions: FilterForRecentTransaction
    var month: Date
    var amountOfExpenses: Double
    var amountOfIncomes: Double
    @Binding var ascendingOrder: Bool

    //Custom type
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    //Environnements
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
            HStack(alignment: .bottom) {
                if filterTransactions == .expenses {
                    VStack(alignment: .leading) {
                        Text(HelperManager().formattedDateWithMonthYear(date: month))
                            .font(.mediumCustom(size: 22))
                        if store.isLifetimeActive {
                            Text(NSLocalizedString("word_expenses", comment: "") + " : " + amountOfExpenses.currency)
                                .lineLimit(1)
                                .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                                .font(.semiBoldSmall())
                        }
                    }
                    Spacer()
                    Button(action: { withAnimation { ascendingOrder.toggle() } }, label: {
                        HStack {
                            Text(NSLocalizedString("word_expenses", comment: ""))
                            Image(systemName: "arrow.up")
                                .rotationEffect(.degrees(ascendingOrder ? 180 : 0))
                        }
                    })
                    .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                    .font(.semiBoldSmall())
                } else if filterTransactions == .incomes {
                    VStack(alignment: .leading) {
                        Text(HelperManager().formattedDateWithMonthYear(date: month))
                            .font(.mediumCustom(size: 22))
                        if store.isLifetimeActive {
                            Text(NSLocalizedString("word_incomes", comment: "") + " : " + amountOfIncomes.currency)
                                .lineLimit(1)
                                .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                                .font(.semiBoldSmall())
                        }
                    }
                    Spacer()
                    Button(action: { withAnimation { ascendingOrder.toggle() } }, label: {
                        HStack {
                            Text(NSLocalizedString("word_incomes", comment: ""))
                            Image(systemName: "arrow.up")
                                .rotationEffect(.degrees(ascendingOrder ? 180 : 0))
                        }
                    })
                    .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                    .font(.semiBoldSmall())
                }
            }
            .font(.mediumCustom(size: 22))
            
            Spacer()
        }
        .padding([.horizontal, .top])
    }//END body
}//END struct

//MARK: - Preview
struct DetailOfExpensesOrIncomes_Previews: PreviewProvider {
    static var previews: some View {
        DetailOfExpensesOrIncomesByMonth(
            filterTransactions: Binding.constant(.expenses),
            month: Date(),
            amountOfExpenses: 200,
            amountOfIncomes: 100,
            ascendingOrder: Binding.constant(false)
        )
    }
}
