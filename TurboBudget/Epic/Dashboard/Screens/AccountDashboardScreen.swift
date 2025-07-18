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
import TheoKit
import DesignSystemModule

struct AccountDashboardScreen: View {
    
    // EnvironmentObject
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var store: PurchasesManager
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var appManager: AppManager
        
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var creditCardStore: CreditCardStore
    
    @StateObject private var viewModel: ViewModel = .init()
    
    // MARK: -
    var body: some View {
        VStack(spacing: 32) {
            HStack {
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
                                    if let account = accountStore.selectedAccount, let accountID = account._id {
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
                
                Spacer()
                
                if !store.isCashFlowPro {
                    PremiumButton()
                }
                
                NavigationButton(route: .push, destination: AppDestination.settings(.home)) {
                    Image(.iconGear)
                        .renderingMode(.template)
                        .foregroundStyle(Color.text)
                }
            }
            
            ScrollView {
                VStack(spacing: 32) {
                    
                    if let account = accountStore.selectedAccount {
                        VStack(spacing: 16) {
                            Menu {
                                ForEach(accountStore.accounts) { account in
                                    Button {
                                        accountStore.setNewAccount(account: account)
                                    } label: {
                                        Text(account.name)
                                    }
                                }
                            } label: {
                                HStack(spacing: DesignSystem.Spacing.small) {
                                    Text(account.name)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                    
                                    Image(.iconChevronUpDown)
                                        .renderingMode(.template)
                                }
                                .fontWithLineHeight(DesignSystem.Fonts.Title.medium)
                                .foregroundStyle(themeManager.theme.color)
                            }
                            .onChange(of: accountStore.selectedAccount?.id) { _ in
                                if appManager.isStartDataLoaded {
                                    appManager.resetAllStoresData()
                                    Task {
                                        await appManager.loadStartData()
                                    }
                                }
                            }
                            
                            VStack(alignment: .center, spacing: 0) {
                                Text(account.balance.toCurrency())
                                    .fontWithLineHeight(DesignSystem.Fonts.Display.extraLarge)
                                    .animation(.default, value: account.balance)
                                    .contentTransition(.numericText())
                                
                                Text("home_screen_available_balance".localized)
                                    .fontWithLineHeight(DesignSystem.Fonts.Body.medium)
                                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                            }
                            .fullWidth()
                        }
                    }
                    
                    VStack(spacing: 16) {LazyVGrid(columns: viewModel.columns, spacing: 16, content: {
                            NavigationButton(route: .push, destination: AppDestination.account(.statistics)) {
                                DashboardRowView(
                                    config: .init(
                                        icon: .iconLineChart,
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
                                DashboardRowView(
                                    config: .init(
                                        icon: .iconLandmark,
                                        text: Word.Main.savingsAccounts
                                    )
                                )
                            }
                            
                            NavigationButton(route: .push, destination: AppDestination.transaction(.list)) {
                                DashboardRowView(
                                    config: .init(
                                        icon: .iconWallet,
                                        text: Word.Main.transactions
                                    )
                                )
                            }
                            
                            NavigationButton(route: .push, destination: AppDestination.subscription(.list)) {
                                DashboardRowView(
                                    config: .init(
                                        icon: .iconClockRepeat,
                                        text: Word.Main.subscriptions
                                    )
                                )
                            }
                            
                            NavigationButton(route: .push, destination: AppDestination.savingsPlan(.list)) {
                                DashboardRowView(
                                    config: .init(
                                        icon: .iconPiggyBank,
                                        text: Word.Main.savingsPlans
                                    )
                                )
                            }
                            
                            NavigationButton(route: .push, destination: AppDestination.budget(.list)) {
                                DashboardRowView(
                                    config: .init(
                                        icon: .iconPieChart,
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
                    
                    Rectangle()
                        .frame(height: 120)
                        .opacity(0)
                } // Main VStack
            }
            .scrollIndicators(.hidden)
        }
        .padding(Padding.large)
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .alert("account_detail_rename".localized, isPresented: $viewModel.isEditingAccountName, actions: {
            TextField("account_detail_new_name".localized, text: $viewModel.accountName)
            Button(action: { return }, label: { Text("word_cancel".localized) })
            Button(action: {
                Task {
                    if let account = accountStore.selectedAccount, let accountID = account._id {
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
                        if let accountID = account._id {
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
    AccountDashboardScreen()
}
