//
//  SavingsAccountDetailView.swift
//  CashFlow
//
//  Created by KaayZenn on 20/02/2024.
//

import SwiftUI
import NavigationKit

struct SavingsAccountDetailView: View {
    
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
        List {
            SavingsAccountInfos(savingsAccount: currentAccount)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            
            ForEach(transferStore.monthsOfTransfers, id: \.self) { month in
                Section(
                    content: {
                        ForEach(transferStore.transfers) { transfer in
                            if Calendar.current.isDate(transfer.date, equalTo: month, toGranularity: .month) {
                                NavigationButton(
                                    route: .push,
                                    destination: AppDestination.transaction(.detail(transaction: transfer))
                                ) {
                                    if transfer.type == .transfer {
                                        TransferRow(transfer: transfer)
                                    } else {
                                        TransactionRow(transaction: transfer, isEditable: false)
                                    }
                                }
                                .environmentObject(savingsAccountStore)
                                .padding(.horizontal)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                        .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
                    },
                    header: {
                    DetailOfTransferByMonth(
                        month: month,
                        amountOfSavings: transferStore.amountOfSavingsByMonth(month: month),
                        amountOfWithdrawal: transferStore.amountOfWithdrawalByMonth(month: month)
                    )
                    .listRowInsets(EdgeInsets(top: -12, leading: 0, bottom: 8, trailing: 0))
                })
                .foregroundStyle(Color.text)
            }
        } // End List
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(savingsAccountStore.currentAccount.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(
                    content: {
                        NavigationButton(
                            route: .sheet,
                            destination: AppDestination.savingsAccount(.createTransaction(savingsAccount: savingsAccountStore.currentAccount))
                        ) {
                            Label(Word.Classic.add, systemImage: "plus")
                        }
                        NavigationButton(
                            route: .sheet,
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
                    },
                    label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.text)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
        }
        .alert("account_detail_delete_account".localized, isPresented: $isDeleting, actions: {
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
        }, message: { Text("account_detail_delete_account_desc".localized) })
        .task {
            if let accountID = savingsAccountStore.currentAccount._id {
                transferStore.transfers = []
                await transferStore.fetchTransfersWithPagination(accountID: accountID)
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsAccountDetailView(savingsAccount: .mockSavingsAccount)
        .environmentObject(ThemeManager())
        .environmentObject(TransferStore())
        .environmentObject(AccountStore())
}
