//
//  SavingsAccountDetailView.swift
//  CashFlow
//
//  Created by KaayZenn on 20/02/2024.
//

import SwiftUI

struct SavingsAccountDetailView: View {
    
    // Builder
    @StateObject private var savingsAccountStore: SavingsAccountStore
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var transferRepository: TransferStore
    @EnvironmentObject private var accountRepository: AccountStore
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var accountNameForDeleting: String = ""
    @State private var isDeleting: Bool = false
    
    // init
    init(savingsAccount: AccountModel) {
        self._savingsAccountStore = StateObject(wrappedValue: .init(currentAccount: savingsAccount))
    }
    
    // MARK: - body
    var body: some View {
        List {
            SavingsAccountInfos(savingsAccount: savingsAccountStore.currentAccount)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            
            ForEach(transferRepository.monthsOfTransfers, id: \.self) { month in
                Section(content: {
                    ForEach(transferRepository.transfers) { transfer in
                        if Calendar.current.isDate(transfer.date, equalTo: month, toGranularity: .month) {
                            Group {
                                if transfer.type == .transfer {
                                    TransferRow(transfer: transfer)
                                        .environmentObject(savingsAccountStore)
                                } else {
                                    TransactionRow(transaction: transfer)
                                        .disabled(true)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                    .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
                }, header: {
                    DetailOfTransferByMonth(
                        month: month,
                        amountOfSavings: transferRepository.amountOfSavingsByMonth(month: month),
                        amountOfWithdrawal: transferRepository.amountOfWithdrawalByMonth(month: month)
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
                Menu(content: {
                    Button(
                        action: { router.presentCreateTransactionForSavingsAccount(savingsAccount: savingsAccountStore.currentAccount) },
                        label: { Label(Word.Classic.add, systemImage: "plus") }
                    )
                    Button(
                        action: { router.presentCreateTransfer(receiverAccount: savingsAccountStore.currentAccount) },
                        label: { Label(Word.Main.transfer, systemImage: "arrow.left.arrow.right") }
                    )
                    Button(
                        action: { router.presentCreateAccount(type: .savings, account: savingsAccountStore.currentAccount) },
                        label: { Label(Word.Classic.edit, systemImage: "pencil") }
                    )
                    Button(
                        role: .destructive,
                        action: { isDeleting.toggle() },
                        label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
                    )
                }, label: {
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
                        if let accountID = savingsAccountStore.currentAccount.id {
                            Task {
                                await accountRepository.deleteAccount(accountID: accountID)
                                dismiss()
                            }
                        }
                    }
                }, label: { Text(Word.Classic.delete) })
        }, message: { Text("account_detail_delete_account_desc".localized) })
        .task {
            if let accountID = savingsAccountStore.currentAccount.id {
                transferRepository.transfers = []
                await transferRepository.fetchTransfersWithPagination(accountID: accountID)
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
