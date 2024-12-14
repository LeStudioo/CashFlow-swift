//
//  TransferRow.swift
//  CashFlow
//
//  Created by KaayZenn on 23/11/2023.
//

import SwiftUI
import SwipeActions

enum TransferRowLocation {
    case successfulSheet, savingsAccount
}

struct TransferRow: View {

    //Custom type
    var transfer: TransactionModel
    var location: TransferRowLocation = .savingsAccount
    @EnvironmentObject private var savingsAccountRepository: SavingsAccountRepository
    @EnvironmentObject private var transferRepository: TransferRepository
    @EnvironmentObject private var accountRepository: AccountRepository
    
    //Environnement
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding Bool
    @State private var isDeleting: Bool = false
    @State private var cancelDeleting: Bool = false
    
    var isSender: Bool {
        switch location {
        case .successfulSheet:
            return accountRepository.selectedAccount?.id == transfer.senderAccountID
        case .savingsAccount:
            return savingsAccountRepository.currentAccount.id == transfer.senderAccountID
        }
    }

    // MARK: -
    var body: some View {
        SwipeView(label: {
            HStack {
                Circle()
                    .foregroundStyle(.color2Apple)
                    .frame(width: 50)
                    .overlay {
                        Circle()
                            .foregroundStyle(isSender ? .error400 : .primary500)
                            .shadow(radius: 4, y: 4)
                            .frame(width: 34)
                        
                        Text(Locale.current.currencySymbol ?? "$")
                            .foregroundStyle(Color(uiColor: .systemBackground))
                    }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(Word.Main.transfer)
                        .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                        .font(Font.mediumSmall())
                    Text(isSender ? Word.Classic.sent : Word.Classic.received)
                        .font(.semiBoldText18())
                        .foregroundStyle(Color(uiColor: .label))
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("\(isSender ? "-" : "+") \((transfer.amount ?? 0).toCurrency())")
                        .font(.semiBoldText16())
                        .foregroundStyle(isSender ? .error400 : .primary500)
                        .lineLimit(1)
                    Text(transfer.date.formatted(date: .numeric, time: .omitted))
                        .font(Font.mediumSmall())
                        .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                        .lineLimit(1)
                }
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.colorCell)
            }
        }, trailingActions: { context in
            SwipeAction(action: {
                withAnimation { isDeleting.toggle() }
            }, label: { _ in
                VStack(spacing: 5) {
                    Image(systemName: "trash")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    Text("word_DELETE".localized)
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
        .padding(.vertical, 4)
        .padding(.horizontal)
        .alert("transfer_detail_delete_transac".localized, isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { cancelDeleting.toggle(); return }, label: { Text("word_cancel".localized) })
            Button(role: .destructive, action: {
                Task {
                    if let transferID = transfer.id {
                        await transferRepository.deleteTransfer(transferID: transferID)
                    }
                }
            }, label: { Text("word_delete".localized) })
        }, message: {
            Text((transfer.amount ?? 0) < 0 ? "transfer_detail_alert_if_expense".localized : "transfer_detail_alert_if_income".localized)
        })
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransferRow(transfer: .mockTransferTransaction)
}
