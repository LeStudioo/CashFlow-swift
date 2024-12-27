//
//  SubscriptionRow.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import SwipeActions
import AlertKit

struct SubscriptionRow: View {
    
    // Builder
    var subscription: SubscriptionModel
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var subscriptionStore: SubscriptionStore
    
    var currentSubscription: SubscriptionModel {
        return subscriptionStore.subscriptions.first { $0.id == subscription.id } ?? subscription
    }
    
    // MARK: -
    var body: some View {
        SwipeView(
            label: {
                HStack {
                    CircleCategory(
                        category: subscription.category,
                        subcategory: subscription.subcategory
                    )
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(Word.Main.subscription)
                            .foregroundStyle(Color.customGray)
                            .font(.Text.medium)
                        
                        Text(subscription.name ?? "")
                            .font(.semiBoldText18())
                            .foregroundStyle(Color(uiColor: .label))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("\(subscription.symbol) \(subscription.amount?.toCurrency() ?? "")")
                            .font(.semiBoldText16())
                            .foregroundStyle(subscription.type == .expense ? .error400 : .primary500)
                            .lineLimit(1)
                        
                        Text(subscription.date.withTemporality)
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
            },
            trailingActions: { context in
                SwipeAction(action: {
                    router.presentCreateSubscription(subscription: subscription)
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
                    AlertManager.shared.deleteSubscription(subscription: subscription)
                    context.state.wrappedValue = .closed
                }, label: { _ in
                    VStack(spacing: 5) {
                        Image(systemName: "trash")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Text(Word.Classic.delete)
                            .font(.semiBoldCustom(size: 10))
                    }
                    .foregroundStyle(Color.textReversed)
                }, background: { _ in
                    Rectangle()
                        .foregroundStyle(.error400)
                })
            }
        )
        .swipeActionsStyle(.cascade)
        .swipeActionWidth(90)
        .swipeActionCornerRadius(16)
        .swipeMinimumDistance(30)
        .padding(.vertical, 4)
    } // body
} // struct

// MARK: - Preview
#Preview {
    SubscriptionRow(subscription: .mockClassicSubscriptionExpense)
}
