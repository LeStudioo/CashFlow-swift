//
//  DetailOfTransferByMonth.swift
//  CashFlow
//
//  Created by KaayZenn on 23/11/2023.
//

import SwiftUI

struct DetailOfTransferByMonth: View {

    //Builder
    var month: Date
    var amountOfSavings: Double
    var amountOfWithdrawal: Double

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
                        if amountOfSavings != 0 {
                            Text("word_savings".localized + " : " + amountOfSavings.currency)
                                .lineLimit(1)
                        }
                        if amountOfSavings != 0 && amountOfWithdrawal != 0 {
                            Text("|")
                        }
                        if amountOfWithdrawal != 0 {
                            Text("word_withdrawal".localized + " : " + amountOfWithdrawal.currency)
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
        .padding([.horizontal, .top])
    } // End body
} // End struct

//MARK: - Preview
#Preview {
    DetailOfTransferByMonth(
        month: .now,
        amountOfSavings: 600,
        amountOfWithdrawal: 100
    )
}
