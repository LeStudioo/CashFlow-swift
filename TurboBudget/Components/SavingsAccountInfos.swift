//
//  SavingsAccountInfos.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI

struct SavingsAccountInfos: View {
    
    // Builder
    @ObservedObject var savingsAccount: AccountModel
    
    @State private var rowHeight: CGFloat = 0
    
    // MARK: -
    var body: some View {
        VStack(spacing: 12) {
            DetailRow(
                icon: "\(UserCurrency.name)sign",
                text: Word.Classic.currentAmount,
                value: savingsAccount.balance.toCurrency()
            )
            .onGetHeight { height in
                rowHeight = height
            }
            
            if let maxAmount = savingsAccount.maxAmount {
                DetailRow(
                    icon: "building.columns.fill",
                    text: Word.Classic.maxAmount,
                    value: maxAmount.toCurrency()
                )
                
                ProgressBar(percentage: savingsAccount.balance / maxAmount)
                    .frame(height: rowHeight - 8)
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
