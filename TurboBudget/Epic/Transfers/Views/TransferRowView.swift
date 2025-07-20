//
//  TransferRowView.swift
//  CashFlow
//
//  Created by KaayZenn on 23/11/2023.
//

import SwiftUI
import SwipeActions
import CoreModule

enum TransferRowLocation {
    case successfulSheet, savingsAccount
}

struct TransferRowView: View {

    // MARK: Dependencies
    var transfer: TransactionModel
    var location: TransferRowLocation = .savingsAccount
    
    // MARK: Environments
    @EnvironmentObject private var savingsAccountRepository: SavingsAccountStore
    @EnvironmentObject private var transferStore: TransferStore
    @EnvironmentObject private var accountStore: AccountStore
        
    // MARK: States
    @State private var isDeleting: Bool = false
    @State private var cancelDeleting: Bool = false
    
    var isSender: Bool {
        switch location {
        case .successfulSheet:
            return accountStore.selectedAccount?._id == transfer.senderAccount?._id
        case .savingsAccount:
            return savingsAccountRepository.currentAccount._id == transfer.senderAccount?._id
        }
    }

    // MARK: - View
    var body: some View {
        SwipeView(label: {
            HStack {
                Circle()
                    .foregroundStyle(.background200)
                    .frame(width: 50)
                    .overlay {
                        Circle()
                            .foregroundStyle(isSender ? .error400 : .primary500)
                            .shadow(radius: 4, y: 4)
                            .frame(width: 34)
                        
                        Image(systemName: isSender ? "antenna.radiowaves.left.and.right" : "tray.fill")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(uiColor: .systemBackground))
                    }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(Word.Main.transfer)
                        .foregroundStyle(Color.customGray)
                        .font(Font.mediumSmall())
                    Text(isSender ? Word.Classic.sent : Word.Classic.received)
                        .font(.semiBoldText18())
                        .foregroundStyle(Color.text)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("\(isSender ? "-" : "+") \((transfer.amount).toCurrency())")
                        .font(.semiBoldText16())
                        .foregroundStyle(isSender ? .error400 : .primary500)
                        .lineLimit(1)
                    Text(transfer.date.formatted(date: .numeric, time: .omitted))
                        .font(Font.mediumSmall())
                        .foregroundStyle(Color.customGray)
                        .lineLimit(1)
                }
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.background100)
            }
        }, trailingActions: { context in
            SwipeAction(action: {
                withAnimation { isDeleting.toggle() }
            }, label: { _ in
                VStack(spacing: 5) {
                    Image(systemName: "trash")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    Text(Word.Classic.delete)
                        .font(.semiBoldCustom(size: 10))
                }
                .foregroundStyle(Color(uiColor: .systemBackground))
            }, background: { _ in
                Rectangle()
                    .foregroundStyle(.error400)
            })
            .onChange(of: cancelDeleting) { _ in
                context.state.wrappedValue = .closed
            }
        })
        .swipeActionsStyle(.cascade)
        .swipeActionWidth(90)
        .swipeActionCornerRadius(15)
        .swipeMinimumDistance(30)
        .alert("transfer_detail_delete_transac".localized, isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { cancelDeleting.toggle(); return }, label: { Text("word_cancel".localized) })
            Button(role: .destructive, action: {
                Task {
                    await transferStore.deleteTransfer(transferID: transfer.id)
                }
            }, label: { Text("word_delete".localized) })
        }, message: {
            Text((transfer.amount) < 0 ? "transfer_detail_alert_if_expense".localized : "transfer_detail_alert_if_income".localized)
        })
    }
}

// MARK: - Preview
#Preview {
    TransferRowView(transfer: .mockTransferTransaction)
}
