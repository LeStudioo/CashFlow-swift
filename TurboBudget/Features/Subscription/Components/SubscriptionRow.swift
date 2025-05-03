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
import NavigationKit
import TheoKit

struct SubscriptionRow: View {
    
    // Builder
    var subscription: SubscriptionModel
    
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var subscriptionStore: SubscriptionStore
    
    var currentSubscription: SubscriptionModel {
        return subscriptionStore.subscriptions.first { $0.id == subscription.id } ?? subscription
    }
    
    // MARK: -
    var body: some View {
        SwipeView(
            label: {
                HStack(spacing: TKDesignSystem.Spacing.medium) {
                    CircleCategory(
                        category: subscription.category,
                        subcategory: subscription.subcategory
                    )
                    
                    VStack(alignment: .leading, spacing: TKDesignSystem.Spacing.extraSmall) {
                        Text(Word.Main.subscription)
                            .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                            .font(TKDesignSystem.Fonts.Body.small)
                        
                        Text(subscription.name)
                            .font(TKDesignSystem.Fonts.Body.medium)
                            .foregroundStyle(Color.text)
                            .lineLimit(1)
                    }
                    .fullWidth(.leading)
                                        
                    VStack(alignment: .trailing, spacing: TKDesignSystem.Spacing.extraSmall) {
                        Text("\(subscription.symbol) \(subscription.amount.toCurrency())")
                            .font(TKDesignSystem.Fonts.Body.mediumBold)
                            .foregroundStyle(subscription.type == .expense ? .error400 : .primary500)
                            .lineLimit(1)
                        
                        Text(subscription.frequencyDate.withTemporality)
                            .font(TKDesignSystem.Fonts.Body.small)
                            .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                            .lineLimit(1)
                    }
                }
                .padding(TKDesignSystem.Padding.medium)
                .roundedRectangleBorder(
                    TKDesignSystem.Colors.Background.Theme.bg100,
                    radius: 16,
                    lineWidth: 1,
                    strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
                )
            },
            trailingActions: { context in
                SwipeAction(action: {
                    router.push(.subscription(.update(subscription: subscription)))
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
    } // body
} // struct

// MARK: - Preview
#Preview {
    SubscriptionRow(subscription: .mockClassicSubscriptionExpense)
}
