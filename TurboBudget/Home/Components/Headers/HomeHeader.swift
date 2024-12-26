//
//  HomeHeader.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import SwiftUI

struct HomeHeader: View {
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountStore
    @EnvironmentObject private var transactionRepository: TransactionStore
    @EnvironmentObject private var purchaseManager: PurchasesManager
    
    // MARK: -
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading) {
                if let account = accountRepository.selectedAccount {
                    Text(account.balance.toCurrency())
                        .titleAdjustSize()
                        .animation(.default, value: account.balance)
                        .contentTransition(.numericText())
                }
                
                Text("home_screen_available_balance".localized)
                    .foregroundStyle(Color.customGray)
                    .font(Font.mediumText16())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if !purchaseManager.isCashFlowPro {
                PremiumButton()
            }
            
            NavigationButton(push: router.pushSettings()) {
                Image(systemName: "gearshape.fill")
                    .foregroundStyle(Color.text)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
            }
        }
//        .onChange(of: transactionRepository.transactions.count) { _ in
//            // Keep to reload account.balance
//        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeHeader()
}
