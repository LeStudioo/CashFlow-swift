//
//  TransactionRow.swift
//  TurboBudget
//
//  Created by Théo Sementa on 17/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import SwipeActions
import AlertKit
import NavigationKit

struct TransactionRow: View {
    
    // Builder
    var transaction: TransactionModel
    var isEditable: Bool = true
    
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var transactionStore: TransactionStore
    @EnvironmentObject private var accountStore: AccountStore
    
    var currentTransaction: TransactionModel {
        return transactionStore.transactions.first { $0.id == transaction.id } ?? transaction
    }
    
    // MARK: -
    var body: some View {
        SwipeView(
            label: {
                HStack {
                    CircleCategory(
                        category: currentTransaction.category,
                        subcategory: currentTransaction.subcategory,
                        transaction: currentTransaction
                    )
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(transactionTypeString)
                            .foregroundStyle(Color.customGray)
                            .font(.Text.medium)
                        
                        Text(currentTransaction.nameDisplayed)
                            .font(.semiBoldText18())
                            .foregroundStyle(Color.text)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("\(currentTransaction.symbol) \(currentTransaction.amount.toCurrency())")
                            .font(.semiBoldText16())
                            .foregroundStyle(currentTransaction.color)
                            .lineLimit(1)
                        
                        Text(currentTransaction.date.withTemporality)
                            .font(.Text.medium)
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
                if isEditable {
                    SwipeAction(action: {
                        router.present(route: .sheet, .transaction(.update(transaction: currentTransaction)))
                        context.state.wrappedValue = .closed
                    }, label: { _ in
                        VStack(spacing: 5) {
                            Image(systemName: "pencil")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            Text(Word.Classic.edit)
                                .font(.semiBoldCustom(size: 10))
                        }
                        .foregroundStyle(Color.textReversed)
                    }, background: { _ in
                        Rectangle()
                            .foregroundStyle(.blue)
                    })
                }
            
            SwipeAction(action: {
                if transaction.type == .transfer {
                    AlertManager.shared.deleteTransfer(transfer: currentTransaction)
                } else {
                    AlertManager.shared.deleteTransaction(transaction: currentTransaction)
                }
                context.state.wrappedValue = .closed
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
        })
        .swipeActionsStyle(.cascade)
        .swipeActionWidth(90)
        .swipeActionCornerRadius(16)
        .swipeMinimumDistance(40)
        .padding(.vertical, 4)
    } // body
} // struct

extension TransactionRow {
    
    var transactionTypeString: String {
        if currentTransaction.isFromSubscription == true {
            return Word.Main.subscription
        } else {
            return currentTransaction.type.name
        }
    }
    
}

// MARK: - Preview
#Preview {
    Group {
        TransactionRow(transaction: .mockClassicTransaction)
        TransactionRow(transaction: .mockClassicTransaction)
    }
    .padding()
    .background(Color.background)
}
