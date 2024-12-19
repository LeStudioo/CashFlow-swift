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
                            .font(.Text.medium)
                        
                        Text(transaction.name)
                            .font(.semiBoldText18())
                            .foregroundStyle(Color.text)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("\(transaction.symbol) \(transaction.amount?.toCurrency() ?? "")")
                            .font(.semiBoldText16())
                            .foregroundStyle(transaction.color)
                            .lineLimit(1)
                        
                        Text(transaction.date.withTemporality)
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
                .foregroundStyle(Color.textReversed)
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
        .swipeActionCornerRadius(15)
        .swipeMinimumDistance(30)
        .padding(.vertical, 4)
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
    .padding()
    .background(Color.background)
}
