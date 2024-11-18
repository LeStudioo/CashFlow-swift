//
//  HomeScreenRecentTransactions.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI

struct HomeScreenRecentTransactions: View {
    
    // EnvironmentObject
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var transactionRepository: TransactionRepository
    
    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared
    
    // MARK: -
    var body: some View {
        if preferencesDisplayHome.transaction_isDisplayed {
            VStack {
                HomeScreenComponentHeader(type: .recentTransactions)
                
                if transactionRepository.transactions.count != 0 {
                    ForEach(transactionRepository.transactions.prefix(preferencesDisplayHome.transaction_value)) { transaction in
                        NavigationButton(push: router.pushTransactionDetail(transaction: transaction)) {
                            TransactionRow(transaction: transaction)
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Image("NoTransaction\(ThemeManager.theme.nameNotLocalized.capitalized)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 4, y: 4)
                            .frame(width: isIPad
                                   ? UIScreen.main.bounds.width / 3
                                   : UIScreen.main.bounds.width / 1.5
                            )
                        
                        Text("home_screen_no_transaction".localized)
                            .font(.semiBoldText16())
                            .multilineTextAlignment(.center)
                    }
                    .offset(y: -20)
                }
                Rectangle()
                    .frame(height: 100)
                    .opacity(0)
                
                Spacer()
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeScreenRecentTransactions()
}
