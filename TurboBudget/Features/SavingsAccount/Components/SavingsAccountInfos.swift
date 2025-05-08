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
    
    @State private var rowHeight: CGFloat = 0
    
    // MARK: -
    var body: some View {
        VStack(spacing: 12) {
            DetailRow(
                icon: .iconCoins,
                text: Word.Classic.currentAmount,
                value: savingsAccount.balance.toCurrency()
            )
            .onGetHeight { height in
                rowHeight = height - 8
            }
            
            if let maxAmount = savingsAccount.maxAmount {
                DetailRow(
                    icon: .iconLandmark,
                    text: Word.Classic.maxAmount,
                    value: maxAmount.toCurrency()
                )
                
                ProgressBar(percentage: savingsAccount.balance / maxAmount)
                    .frame(height: rowHeight)
            }
        }
    } // body
} // struct

// MARK: -
#Preview {
    SavingsAccountInfos(savingsAccount: .mockSavingsAccount)
        .padding()
        .background(Color.background)
        .environmentObject(ThemeManager())
}
