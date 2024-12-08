//
//  SavingsAccountHomeView.swift
//  CashFlow
//
//  Created by KaayZenn on 23/11/2023.
//

import SwiftUI

struct SavingsAccountHomeView: View {
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var purchaseManager: PurchasesManager
    @EnvironmentObject private var accountRepository: AccountRepository
    @Environment(\.dismiss) private var dismiss
    
    // Computed variables
    var totalSavings: Double {
        return accountRepository.savingsAccounts
            .map { $0.balance }
            .reduce(0, +)
    }
    
    var columns: [GridItem] {
        if isIPad {
            return [GridItem(), GridItem(), GridItem(), GridItem()]
        } else {
            return [GridItem(), GridItem()]
        }
    }
    
    // MARK: -
    var body: some View {
        ScrollView {
            if !accountRepository.savingsAccounts.isEmpty {
                VStack(spacing: -2) {
                    Text(Word.SavingsAccount.totalSavings)
                        .font(Font.mediumText16())
                        .foregroundStyle(Color.customGray)
                    HStack {
                        Text(currencySymbol)
                        Text(totalSavings.toCurrency())
                    }
                    .font(.boldH1())
                }
                .padding(.vertical, 12)
                
                LazyVGrid(columns: columns, spacing: 12, content: {
                    ForEach(accountRepository.savingsAccounts) { account in
                        NavigationButton(push: router.pushSavingsAccountDetail(savingsAccount: account)) {
                            SavingsAccountRow(savingsAccount: account)
                        }
                    }
                })
                .padding(.horizontal, 8)
            } else {
                CustomEmptyView(
                    type: .empty(.savingsAccount),
                    isDisplayed: true
                )
            }
        }
        .navigationTitle(Word.Main.savingsAccounts)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
                        
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if purchaseManager.isCashFlowPro || accountRepository.savingsAccounts.isEmpty {
                        router.presentCreateAccount(type: .savings)
                    } else {
                        alertManager.showPaywall()
                    }
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsAccountHomeView()
}
