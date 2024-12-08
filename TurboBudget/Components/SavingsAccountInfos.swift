//
//  SavingsAccountInfos.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI

struct SavingsAccountInfos: View {
    
    // Builder
    var savingsAccount: AccountModel
    
    // MARK: -
    var body: some View {
        VStack(spacing: 12) {
            DetailRow(
                icon: "\(currencyName)sign",
                text: Word.Classic.currentAmount,
                value: savingsAccount.balance.toCurrency()
            )
        }
    } // body
} // struct

// MARK: -
#Preview {
    SavingsAccountInfos(savingsAccount: .mockSavingsAccount)
}
