//
//  SavingsAccountDetailScreen.swift
//  CashFlow
//
//  Created by KaayZenn on 20/02/2024.
//

import SwiftUI
import NavigationKit
import StatsKit
import TheoKit

struct SavingsAccountDetailScreen: View {
    
    // Builder
    @StateObject private var savingsAccountStore: SavingsAccountStore
    
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var transferStore: TransferStore
    @EnvironmentObject private var accountStore: AccountStore
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var accountNameForDeleting: String = ""
    @State private var isDeleting: Bool = false
    
    var currentAccount: AccountModel {
        return accountStore.savingsAccounts.first { $0._id == savingsAccountStore.currentAccount._id }  ?? savingsAccountStore.currentAccount
    }
    
    // init
    init(savingsAccount: AccountModel) {
        self._savingsAccountStore = StateObject(wrappedValue: .init(currentAccount: savingsAccount))
    }
    
    // MARK: - body
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarWithMenu(title: savingsAccountStore.currentAccount.name) {
//                NavigationButton( // TODO: Reactivate
//                    route: .push,
//                    destination: AppDestination.savingsAccount(.createTransaction(savingsAccount: savingsAccountStore.currentAccount))
//                ) {
//                    Label(Word.Classic.add, systemImage: "plus")
//                }
                NavigationButton(
                    route: .push,
                    destination: AppDestination.transfer(.create(receiverAccount: savingsAccountStore.currentAccount))
                ) {
                    Label(Word.Main.transfer, systemImage: "arrow.left.arrow.right")
                }
                NavigationButton(
                    route: .sheet,
                    destination: AppDestination.savingsAccount(.update(savingsAccount: savingsAccountStore.currentAccount))
                ) {
                    Label(Word.Classic.edit, systemImage: "pencil")
                }
                Button(
                    role: .destructive,
                    action: { isDeleting.toggle() },
                    label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
                )
            }
            List {
                SavingsAccountInfosView(savingsAccount: currentAccount)
                    .noDefaultStyle()
                    .padding(.horizontal, TKDesignSystem.Padding.large)
                
                ForEach(transferStore.monthsOfTransfers, id: \.self) { month in
                    Section {
                        ForEach(transferStore.transfers) { transfer in
                            if Calendar.current.isDate(transfer.date, equalTo: month, toGranularity: .month) {
                                NavigationButton(
                                    route: .push,
                                    destination: AppDestination.transaction(.detail(transaction: transfer))
                                ) {
                                    if transfer.type == .transfer {
                                        TransferRowView(transfer: transfer)
                                    } else {
                                        TransactionRowView(transaction: transfer, isEditable: false)
                                    }
                                }
                                .environmentObject(savingsAccountStore)
                                .padding(.bottom, TKDesignSystem.Padding.medium)
                                .padding(.horizontal, TKDesignSystem.Padding.large)
                            }
                        }
                        .noDefaultStyle()
                    } header: {
                        DetailOfTransferByMonth(
                            month: month,
                            amountOfSavings: transferStore.amountOfSavingsByMonth(month: month),
                            amountOfWithdrawal: transferStore.amountOfWithdrawalByMonth(month: month)
                        )
                        .padding(.horizontal, TKDesignSystem.Padding.large)
                    }
                    .foregroundStyle(Color.label)
                }
            } // End List
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .padding(.top, TKDesignSystem.Padding.large)
        }
        .navigationBarBackButtonHidden(true)
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .alert(
            "account_detail_delete_account".localized,
            isPresented: $isDeleting,
            actions: {
                TextField(savingsAccountStore.currentAccount.name, text: $accountNameForDeleting)
                Button(role: .cancel, action: { return }, label: { Text("word_cancel".localized) })
                Button(role: .destructive, action: {
                    if savingsAccountStore.currentAccount.name == accountNameForDeleting {
                        if let accountID = savingsAccountStore.currentAccount._id {
                            Task {
                                await accountStore.deleteAccount(accountID: accountID)
                                dismiss()
                            }
                        }
                    }
                }, label: { Text(Word.Classic.delete) })
            }, message: { Text("account_detail_delete_account_desc".localized) }
        )
        .task {
            if let accountID = savingsAccountStore.currentAccount._id {
                transferStore.transfers = []
                await transferStore.fetchTransfersWithPagination(accountID: accountID)
            }
        }
        .onAppear {
            EventService.sendEvent(key: .accountSavingsDetailPage)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsAccountDetailScreen(savingsAccount: .mockSavingsAccount)
        .environmentObject(ThemeManager())
        .environmentObject(TransferStore())
        .environmentObject(AccountStore())
}
