//
//  TransactionRow.swift
//  TurboBudget
//
//  Created by Théo Sementa on 17/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import SwipeActions

struct TransactionRow: View {
    
    // Builder
    @ObservedObject var transaction: TransactionModel
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var transactionRepository: TransactionRepository
    @EnvironmentObject private var accountRepository: AccountRepository
    @EnvironmentObject private var alertManager: AlertManager
        
    // State or Binding Bool
    @State private var isEditing: Bool = false
    @State private var isDeleting: Bool = false
    @State private var cancelDeleting: Bool = false
    @State private var isSharingJSON: Bool = false
    @State private var isSharingQRCode: Bool = false
    
    // MARK: -
    var body: some View {
        SwipeView(
            label: {
                HStack {
                    CircleCategory(
                        category: transaction.category,
                        subcategory: transaction.subcategory,
                        transaction: transaction
                    )
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(transactionTypeString)
                            .foregroundStyle(Color.customGray)
                            .font(Font.mediumSmall())
                        
                        Text(transactionName)
                            .font(.semiBoldText18())
                            .foregroundStyle(Color(uiColor: .label))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text(transaction.amount?.currency ?? "")
                            .font(.semiBoldText16())
                            .foregroundStyle(transactionColor)
                            .lineLimit(1)
                        
                        Text(transaction.date.formatted(date: .numeric, time: .omitted))
                            .font(Font.mediumSmall())
                            .foregroundStyle(Color.customGray)
                            .lineLimit(1)
                    }
                }
                .padding(12)
                .background(Color.colorCell)
                .cornerRadius(15)
            }, trailingActions: { context in
            SwipeAction(action: {
                router.presentCreateTransaction(transaction: transaction)
            }, label: { _ in
                VStack(spacing: 5) {
                    Image(systemName: "pencil")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    Text(Word.Classic.edit)
                        .font(.semiBoldCustom(size: 10))
                }
                .foregroundStyle(Color(uiColor: .systemBackground))
            }, background: { _ in
                Rectangle()
                    .foregroundStyle(.blue)
            })
            .onChange(of: isSharingQRCode) { _ in
                context.state.wrappedValue = .closed
            }
            
            SwipeAction(action: {
                alertManager.deleteTransaction(transaction: transaction)
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
//        .sheet(isPresented: $isSharingQRCode) {
//            QRCodeForTransactionSheetView(qrcode: QRCodeManager().generateQRCode(transaction: transaction)!)
//        }
//        .background(SharingViewController(isPresenting: $isSharingJSON) {
//            let json = JSONManager().generateJSONForTransaction(transaction: transaction)
//            let av = UIActivityViewController(activityItems: [json], applicationActivities: nil)
//            
//            // For iPad
//            if UIDevice.current.userInterfaceIdiom == .pad { av.popoverPresentationController?.sourceView = UIView() }
//            
//            av.completionWithItemsHandler = { _, _, _, _ in
//                isSharingJSON = false // required for re-open !!!
//            }
//            return av
//        })
    } // body
} // struct

extension TransactionRow {
    
    var isSender: Bool {
        guard let selectedAccount = accountRepository.selectedAccount, let accountID = selectedAccount.id else { return false }
        return transaction.senderAccountID == accountID
    }

    var transactionName: String {
        switch transaction.type {
        case .expense, .income:
            return transaction.name ?? ""
        case .transfer:
            return isSender ? Word.Classic.sent : Word.Classic.received
        }
    }
    
    var transactionTypeString: String {
        if transaction.isFromSubscription == true {
            return Word.Classic.subscription
        } else {
            switch transaction.type {
            case .expense:
                return Word.Classic.expense
            case .income:
                return Word.Classic.income
            case .transfer:
                return Word.Classic.transfer
            }
        }
    }
    
    var transactionColor: Color {
        switch transaction.type {
        case .expense:
            return .error400
        case .income:
            return .primary500
        case .transfer:
            return isSender ? .error400 : .primary500
        }
    }
    
}

// MARK: - Preview
#Preview {
    Group {
        TransactionRow(transaction: .mockClassicTransaction)
        TransactionRow(transaction: .mockClassicTransaction)
    }
}
