//
//  AccountDashboardView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import AlertKit
import NavigationKit

struct AccountDashboardView: View {
    
    // EnvironmentObject
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var store: PurchasesManager
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var appManager: AppManager
        
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var creditCardStore: CreditCardStore
    
    @StateObject private var viewModel: AccountDashboardViewModel = .init()
    
    // MARK: -
    var body: some View {
        ScrollView {
            if let account = accountStore.selectedAccount {
                VStack {
                    Menu {
                        ForEach(accountStore.accounts) { account in
                            Button {
                                accountStore.setNewAccount(account: account)
                            } label: {
                                Text(account.name)
                            }
                        }
                    } label: {
                        Text(account.name)
                            .titleAdjustSize()
                            .foregroundStyle(themeManager.theme.color)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .onChange(of: accountStore.selectedAccount) { _ in
                        if appManager.isStartDataLoaded {
                            appManager.resetAllStoresData()
                            Task {
                                await appManager.loadStartData()
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                            Text(account.balance.toCurrency())
                                .titleAdjustSize()
                                .animation(.default, value: account.balance)
                                .contentTransition(.numericText())
                        
                        Text("home_screen_available_balance".localized)
                            .foregroundStyle(Color.customGray)
                            .font(Font.mediumText16())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
            
            VStack(spacing: 16) {
                NavigationButton(route: .push, destination: AppDestination.account(.statistics)) {
                    DashboardRow(
                        config: .init(
                            style: .row,
                            icon: "chart.xyaxis.line",
                            text: Word.Classic.statistics
                        )
                    )
                }
                .disabled(!store.isCashFlowPro)
                .onTapGesture {
                    if !store.isCashFlowPro {
                        alertManager.showPaywall(router: router)
                    }
                }
                
                NavigationButton(route: .push, destination: AppDestination.savingsAccount(.list)) {
                    DashboardRow(
                        config: .init(
                            icon: "building.columns.fill",
                            text: Word.Main.savingsAccounts
                        )
                    )
                }
                
                LazyVGrid(columns: viewModel.columns, spacing: 16, content: {
                    NavigationButton(route: .push, destination: AppDestination.transaction(.list)) {
                        DashboardRow(
                            config: .init(
                                icon: "creditcard.and.123",
                                text: Word.Main.transactions
                            )
                        )
                    }
                    
                    NavigationButton(route: .push, destination: AppDestination.subscription(.list)) {
                        DashboardRow(
                            config: .init(
                                icon: "gearshape.2.fill",
                                text: Word.Main.subscriptions
                            )
                        )
                    }
                    
                    NavigationButton(route: .push, destination: AppDestination.savingsPlan(.list)) {
                        DashboardRow(
                            config: .init(
                                icon: "dollarsign.square.fill",
                                text: Word.Main.savingsPlans
                            )
                        )
                    }
                    
                    NavigationButton(route: .push, destination: AppDestination.budget(.list)) {
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
                            alertManager.showPaywall(router: router)
                        }
                    }
                })
                
                if let creditCard = creditCardStore.creditCards.first {
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
                    if let account = accountStore.selectedAccount {
                        Button(
                            action: {
                                router.present(route: .sheet, .account(.update(account: account)))
                            },
                            label: { Label(Word.Classic.edit, systemImage: "pencil") }
                        )
                    }
                    
                    if let creditCard = creditCardStore.creditCards.first, let uuid = creditCard.uuid {
                        Button(
                            role: .destructive,
                            action: {
                                Task {
                                    if let account = accountStore.selectedAccount, let accountID = account.id {
                                        await creditCardStore.deleteCreditCard(accountID: accountID, cardID: uuid)
                                    }
                                }
                            },
                            label: { Label(Word.CreditCard.deleteTitle, systemImage: "trash.fill") }
                        )
                    }
                    
                    Button(
                        role: .destructive,
                        action: { viewModel.isDeleting.toggle() },
                        label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
                    )
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.text)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    if !store.isCashFlowPro {
                        PremiumButton()
                    }
                    NavigationButton(route: .push, destination: AppDestination.settings(.home)) {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(Color.text)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .alert("account_detail_rename".localized, isPresented: $viewModel.isEditingAccountName, actions: {
            TextField("account_detail_new_name".localized, text: $viewModel.accountName)
            Button(action: { return }, label: { Text("word_cancel".localized) })
            Button(action: {
                Task {
                    if let account = accountStore.selectedAccount, let accountID = account.id {
                        await accountStore.updateAccount(accountID: accountID, body: .init(name: viewModel.accountName))
                    }
                }
            }, label: { Text("word_validate".localized) })
        })
        .alert("account_detail_delete_account".localized, isPresented: $viewModel.isDeleting, actions: {
            if let account = accountStore.selectedAccount {
                TextField(account.name, text: $viewModel.accountNameForDeleting)
                Button(role: .cancel, action: { return }, label: { Text("word_cancel".localized) })
                Button(role: .destructive, action: {
                    if account.name == viewModel.accountNameForDeleting {
                        if let accountID = account.id {
                            Task {
                                await accountStore.deleteAccount(accountID: accountID)
                                accountStore.setNewAccount(account: accountStore.accounts.first)
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
