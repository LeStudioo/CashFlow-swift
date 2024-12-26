//
//  DetailOfTransferByMonth.swift
//  CashFlow
//
//  Created by KaayZenn on 23/11/2023.
//

import SwiftUI

struct DetailOfTransferByMonth: View {

    // Builder
    var month: Date
    var amountOfSavings: Double
    var amountOfWithdrawal: Double

    // Environnement
    @EnvironmentObject var store: PurchasesManager

    // MARK: -
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(month.formatted(.monthAndYear).capitalized)
                    .font(.mediumCustom(size: 22))
                if store.isCashFlowPro {
                    HStack {
                        if amountOfSavings != 0 {
                            Text("word_savings".localized + " : " + amountOfSavings.toCurrency())
                                .lineLimit(1)
                        }
                        if amountOfSavings != 0 && amountOfWithdrawal != 0 {
                            Text("|")
                        }
                        if amountOfWithdrawal != 0 {
                            Text("word_withdrawal".localized + " : " + amountOfWithdrawal.toCurrency())
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .foregroundStyle(Color.customGray)
                    .font(.semiBoldSmall())
                }
            }
            Spacer()
        }
        .padding([.horizontal, .top])
    } // body
} // struct

// MARK: - Preview
#Preview {
    DetailOfTransferByMonth(
        month: .now,
        amountOfSavings: 600,
        amountOfWithdrawal: 100
    )
}
