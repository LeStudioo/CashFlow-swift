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
    
    //Environnements
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var store: Store

    //MARK: - Body
    var body: some View {
        HStack {
            HStack(alignment: .bottom) {
                if filterTransactions == .expenses {
                    VStack(alignment: .leading) {
                        Text(HelperManager().formattedDateWithMonthYear(date: month))
                            .font(.mediumCustom(size: 22))
                            .foregroundStyle(Color(uiColor: .label))
                        
                        if store.isLifetimeActive {
                            Text("word_expenses".localized + " : " + amountOfExpenses.currency)
                                .lineLimit(1)
                                .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                                .font(.semiBoldSmall())
                        }
                    }
                    Spacer()
                    Button(action: { withAnimation { ascendingOrder.toggle() } }, label: {
                        HStack {
                            Text("word_expenses".localized)
                            Image(systemName: "arrow.up")
                                .rotationEffect(.degrees(ascendingOrder ? 180 : 0))
                        }
                    })
                    .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                    .font(.semiBoldSmall())
                } else if filterTransactions == .incomes {
                    VStack(alignment: .leading) {
                        Text(HelperManager().formattedDateWithMonthYear(date: month))
                            .font(.mediumCustom(size: 22))
                        if store.isLifetimeActive {
                            Text("word_incomes".localized + " : " + amountOfIncomes.currency)
                                .lineLimit(1)
                                .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                                .font(.semiBoldSmall())
                        }
                    }
                    Spacer()
                    Button(action: { withAnimation { ascendingOrder.toggle() } }, label: {
                        HStack {
                            Text("word_incomes".localized)
                            Image(systemName: "arrow.up")
                                .rotationEffect(.degrees(ascendingOrder ? 180 : 0))
                        }
                    })
                    .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                    .font(.semiBoldSmall())
                }
            }
            .font(.mediumCustom(size: 22))
            
            Spacer()
        }
        .padding(.horizontal)
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
