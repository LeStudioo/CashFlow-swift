//
//  TransactionRowView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 17/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import SwipeActions
import AlertKit
import NavigationKit
import TheoKit
import DesignSystemModule
import CoreModule

struct TransactionRowView: View {
    
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
                HStack(spacing: Spacing.medium) {
                    CircleCategory(
                        category: currentTransaction.category,
                        subcategory: currentTransaction.subcategory,
                        transaction: currentTransaction
                    )
                    
                    VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                        Text(transactionTypeString)
                            .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                            .fontWithLineHeight(.Body.small)
                        
                        Text(currentTransaction.nameDisplayed)
                            .fontWithLineHeight(.Body.medium)
                            .foregroundStyle(Color.text)
                            .lineLimit(1)
                    }
                    .fullWidth(.leading)
                                        
                    VStack(alignment: .trailing, spacing: Spacing.extraSmall) {
                        Text("\(currentTransaction.symbol) \(currentTransaction.amount.toCurrency())")
                            .fontWithLineHeight(.Body.mediumBold)
                            .foregroundStyle(currentTransaction.color)
                            .lineLimit(1)
                        
                        Text(currentTransaction.date.withTemporality)
                            .fontWithLineHeight(.Body.small)
                            .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                            .lineLimit(1)
                    }
                }
                .padding(Padding.medium)
                .roundedRectangleBorder(
                    TKDesignSystem.Colors.Background.Theme.bg100,
                    radius: 16,
                    lineWidth: 1,
                    strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
                )
            },
            trailingActions: { context in
                if isEditable {
                    SwipeAction(action: {
                        router.push(.transaction(.update(transaction: currentTransaction)))
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
    } // body
} // struct

extension TransactionRowView {
    
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
        TransactionRowView(transaction: .mockClassicTransaction)
        TransactionRowView(transaction: .mockClassicTransaction)
    }
    .padding()
    .background(Color.background)
}
