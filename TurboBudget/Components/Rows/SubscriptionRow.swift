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
    @EnvironmentObject private var subscriptionRepository: SubscriptionRepository
    @Environment(\.colorScheme) private var colorScheme
    
    // Boolean variables
    @State private var isDeleting: Bool = false
    @State private var cancelDeleting: Bool = false
    
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
                        Text(Word.Classic.subscription)
                            .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                            .font(Font.mediumSmall())
                        Text(subscription.name ?? "")
                            .font(.semiBoldText18())
                            .foregroundStyle(Color(uiColor: .label))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text(subscription.amount?.currency ?? "")
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
                .background(Color.colorCell)
                .cornerRadius(15)
            },
            trailingActions: { context in
            SwipeAction(action: {
                isDeleting.toggle()
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
        .alert("transaction_cell_delete_auto".localized, isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { cancelDeleting.toggle(); return }, label: { Text("word_cancel".localized) })
            Button(
                role: .destructive,
                action: {
                    if let subscriptionID = subscription.id {
                        Task {
                            await subscriptionRepository.deleteSubscription(subscriptionID: subscriptionID)
                        }
                    }
                },
                label: { Text("word_delete".localized) }
            )
        }, message: {
            Text("transaction_cell_delete_auto_desc".localized)
        })
    } // body
} // struct

// MARK: - Preview
#Preview {
    SubscriptionRow(subscription: .mockClassicSubscriptionExpense)
}
