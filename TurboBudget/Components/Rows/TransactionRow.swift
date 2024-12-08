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
                        
                        Text(transaction.name)
                            .font(.semiBoldText18())
                            .foregroundStyle(Color(uiColor: .label))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("\(transaction.symbol) \(transaction.amount?.toCurrency() ?? "")")
                            .font(.semiBoldText16())
                            .foregroundStyle(transaction.color)
                            .lineLimit(1)
                        
                        Text(transaction.date.withTemporality)
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
                context.state.wrappedValue = .closed
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
            
            SwipeAction(action: {
                alertManager.deleteTransaction(transaction: transaction)
                context.state.wrappedValue = .closed
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
    
    var transactionTypeString: String {
        if transaction.isFromSubscription == true {
            return Word.Main.subscription
        } else {
            return transaction.type.name
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
