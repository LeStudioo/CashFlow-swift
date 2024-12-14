//
//  AccountDashboardView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct AccountDashboardView: View {
    
    // EnvironmentObject
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var store: PurchasesManager
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var themeManager: ThemeManager
        
    @EnvironmentObject private var accountRepository: AccountRepository
    @EnvironmentObject private var creditCardRepository: CreditCardRepository
    
    //State or Binding String
    @State private var accountName: String = ""
    @State private var accountNameForDeleting: String = ""
    
    //State or Binding Bool
    @State private var isDeleting: Bool = false
    @State private var isEditingAccountName: Bool = false
    
    // Computed var
    var columns: [GridItem] {
        if isIPad {
            return [GridItem(spacing: 16), GridItem(spacing: 16), GridItem(spacing: 16), GridItem(spacing: 16)]
        } else {
            return [GridItem(spacing: 16), GridItem(spacing: 16)]
        }
    }
    
    // MARK: -
    var body: some View {
        ScrollView {
            if let account = accountRepository.selectedAccount {
                VStack {
                    Text(account.name)
                        .titleAdjustSize()
                        .foregroundStyle(themeManager.theme.color)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    VStack(spacing: -2) {
                        Text("account_detail_avail_balance".localized)
                            .font(Font.mediumText16())
                            .foregroundStyle(Color.customGray)
                        
                        Text(currencySymbol + " " + account.balance.formatWith(2))
                            .titleAdjustSize()
                    }
                    .padding(.vertical, 12)
                }
            }
            
            VStack(spacing: 16) {
                if store.isCashFlowPro {
                    DashboardChart()
                }
                
                NavigationButton(push: router.pushAllSavingsAccount()) {
                    DashboardRow(
                        config: .init(
                            icon: "building.columns.fill",
                            text: Word.Main.savingsAccounts
                        )
                    )
                }
                
                LazyVGrid(columns: columns, spacing: 16, content: {
                    NavigationButton(push: router.pushAllTransactions()) {
                        DashboardRow(
                            config: .init(
                                icon: "creditcard.and.123",
                                text: Word.Main.transactions
                            )
                        )
                    }
                    
                    NavigationButton(push: router.pushHomeAutomations()) {
                        DashboardRow(
                            config: .init(
                                icon: "gearshape.2.fill",
                                text: Word.Main.subscriptions
                            )
                        )
                    }
                    
                    NavigationButton(push: router.pushHomeSavingPlans()) {
                        DashboardRow(
                            config: .init(
                                icon: "dollarsign.square.fill",
                                text: Word.Main.savingsPlans
                            )
                        )
                    }
                    
                    NavigationButton(push: router.pushAllBudgets()) {
                        DashboardRow(
                            config: .init(
                                icon: "chart.pie.fill",
                                text: "word_budgets".localized,
                                isLocked: !store.isCashFlowPro
                            )
                        )
                    }
                    .disabled(!store.isCashFlowPro)
                    .onTapGesture {
                        if !store.isCashFlowPro {
                            alertManager.showPaywall()
                        }
                    }
                })
                
                if let creditCard = creditCardRepository.creditCards.first {
                    CreditCardView(creditCard: creditCard)
                }
            }
            .padding(.horizontal)
            
            Rectangle()
                .frame(height: 120)
                .opacity(0)
        }
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu(content: {
                    if let account = accountRepository.selectedAccount {
                        Button(
                            action: { router.presentCreateAccount(type: .classic, account: account) },
                            label: { Label(Word.Classic.edit, systemImage: "pencil") }
                        )
                    }
                    
                    if let creditCard = creditCardRepository.creditCards.first, let uuid = creditCard.uuid {
                        Button(
                            role: .destructive,
                            action: {
                                Task {
                                    if let account = accountRepository.selectedAccount, let accountID = account.id {
                                        await creditCardRepository.deleteCreditCard(accountID: accountID, cardID: uuid)
                                    }
                                }
                            },
                            label: { Label(Word.CreditCard.deleteTitle, systemImage: "trash.fill") }
                        )
                    }
                    
                    Button(
                        role: .destructive,
                        action: { isDeleting.toggle() },
                        label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
                    )
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.label)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    if !store.isCashFlowPro {
                        PremiumButton()
                    }
                    
                    NavigationButton(push: router.pushSettings()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(Color.label)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .alert("account_detail_rename".localized, isPresented: $isEditingAccountName, actions: {
            TextField("account_detail_new_name".localized, text: $accountName)
            Button(action: { return }, label: { Text("word_cancel".localized) })
            Button(action: {
                Task {
                    if let account = accountRepository.selectedAccount, let accountID = account.id {
                        await accountRepository.updateAccount(accountID: accountID, body: .init(name: accountName))
                    }
                }
            }, label: { Text("word_validate".localized) })
        })
        .alert("account_detail_delete_account".localized, isPresented: $isDeleting, actions: {
            if let account = accountRepository.selectedAccount {
                TextField(account.name, text: $accountNameForDeleting)
                Button(role: .cancel, action: { return }, label: { Text("word_cancel".localized) })
                Button(role: .destructive, action: {
                    if account.name == accountNameForDeleting {
                        if let accountID = account.id {
                            Task {
                                await accountRepository.deleteAccount(accountID: accountID)
                                accountRepository.selectedAccount = accountRepository.accounts.first
                                TokenManager.shared.setTokenAndRefreshToken(token: "", refreshToken: "")
                            }
                        }
                    }
                }, label: { Text("word_delete".localized) })
            }
        }, message: { Text("account_detail_delete_account_desc".localized) })
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    AccountDashboardView()
}
