//
//  SubscriptionRow.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import SwipeActions

struct SubscriptionRow: View {
    
    // Builder
    @ObservedObject var subscription: SubscriptionModel
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var subscriptionRepository: SubscriptionRepository
    @EnvironmentObject private var alertManager: AlertManager
    
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
                            .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                            .font(Font.mediumSmall())
                        Text(subscription.name ?? "")
                            .font(.semiBoldText18())
                            .foregroundStyle(Color(uiColor: .label))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("\(subscription.symbol) \(subscription.amount?.currency ?? "")")
                            .font(.semiBoldText16())
                            .foregroundStyle(subscription.type == .expense ? .error400 : .primary500)
                            .lineLimit(1)
                        
                        Text(subscription.date.formatted(date: .numeric, time: .omitted))
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
                    .foregroundStyle(Color(uiColor: .systemBackground))
                }, background: { _ in
                    Rectangle()
                        .foregroundStyle(.blue)
                })
                SwipeAction(action: {
                    alertManager.deleteSubscription(subscription: subscription)
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
