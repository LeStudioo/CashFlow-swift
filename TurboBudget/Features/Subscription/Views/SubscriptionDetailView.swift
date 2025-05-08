//
//  SubscriptionDetailView.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/12/2024.
//

import SwiftUI
import AlertKit
import NavigationKit
import StatsKit
import TheoKit

struct SubscriptionDetailView: View {
    
    // Builder
    var subscriptionId: Int
    
    // Custom type
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var subscriptionStore: SubscriptionStore
    @StateObject var viewModel: SubscriptionDetailViewModel = .init()
    
    // Environement
    @Environment(\.dismiss) private var dismiss
    
    var subscription: SubscriptionModel? {
        return subscriptionStore.subscriptions.first { $0.id == subscriptionId }
    }
    
    // MARK: -
    var body: some View {
        if let subscription {
            VStack(spacing: TKDesignSystem.Spacing.extraLarge) {
                NavigationBarWithMenu {
                    NavigationButton(
                        route: .push,
                        destination: AppDestination.subscription(.update(subscription: subscription))
                    ) {
                        Label(Word.Classic.edit, systemImage: "pencil")
                    }
                    Button(
                        role: .destructive,
                        action: { AlertManager.shared.deleteSubscription(subscription: subscription, dismissAction: dismiss) },
                        label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
                    )
                }
                
                ScrollView(.vertical) {
                    VStack(spacing: TKDesignSystem.Spacing.extraLarge) {
                        VStack(spacing: TKDesignSystem.Spacing.extraSmall) {
                            Text("\(subscription.symbol) \(subscription.amount.toCurrency())")
                                .fontWithLineHeight(DesignSystem.Fonts.Display.huge)
                                .foregroundColor(subscription.color)
                            
                            Text(subscription.name)
                                .fontWithLineHeight(DesignSystem.Fonts.Display.small)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        
                        VStack(spacing: 24) {
                            VStack(spacing: 12) {
                                DetailRow(
                                    icon: .iconClockRepeat,
                                    text: Word.Classic.frequency,
                                    value: subscription.frequency.name
                                )
                                
                                DetailRow(
                                    icon: .iconCalendar,
                                    text: "subscription_next_transaction".localized,
                                    value: subscription.frequencyDate.formatted(date: .complete, time: .omitted).capitalized
                                )
                            }
                            
                            VStack(spacing: 12) {
                                if let category = subscription.category {
                                    DetailRow(
                                        icon: category.icon,
                                        value: category.name,
                                        iconBackgroundColor: category.color) {
                                            presentChangeCategory()
                                        }
                                    
                                    if let subcategory = subscription.subcategory {
                                        DetailRow(
                                            icon: subcategory.icon,
                                            value: subcategory.name,
                                            iconBackgroundColor: subcategory.color) {
                                                presentChangeCategory()
                                            }
                                    }
                                }
                            }
                            
                            if let firstSubscriptionDate = subscription.firstSubscriptionDate {
                                VStack(spacing: 12) {
                                    DetailRow(
                                        icon: .iconCalendar,
                                        text: "subscription_first_subscription".localized,
                                        value: firstSubscriptionDate.formatted(date: .complete, time: .omitted).capitalized
                                    )
                                    
                                    //                                DetailRow(
                                    //                                    icon: "dollarsign",
                                    //                                    text: "Date since".localized,
                                    //                                    value: firstSubscriptionDate.monthsBetween(.now).formatted()
                                    //                                )
                                }
                            }
                        }
                        
                        if let transactions = subscription.transactions {
                            VStack(spacing: 16) {
                                Text("word_transactions".localized + " (\(transactions.count) - \(transactions.map(\.amount).reduce(0, +).toCurrency()))")
                                    .fullWidth(.leading)
                                    .font(.mediumCustom(size: 20))
                                
                                VStack(spacing: 0) {
                                    ForEach(transactions.sorted(by: { $0.date > $1.date })) { transaction in
                                        NavigationButton(
                                            route: .push,
                                            destination: AppDestination.transaction(.detail(transaction: transaction))
                                        ) {
                                            TransactionRow(transaction: transaction)
                                                .padding(.bottom, TKDesignSystem.Padding.medium)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, TKDesignSystem.Padding.large)
                } // ScrollView
                .scrollIndicators(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarDismissKeyboardButtonView()
            }
            .background(TKDesignSystem.Colors.Background.Theme.bg50)
            .onAppear {
                EventService.sendEvent(key: .subscriptionDetailPage)
            }
        }
    } // body
} // struct

// MARK: - Utils
extension SubscriptionDetailView {

    // TODO: DUPLICATED
    func presentChangeCategory() {
        router.present(
            route: .sheet,
            .category(.select(
                selectedCategory: $viewModel.selectedCategory,
                selectedSubcategory: $viewModel.selectedSubcategory
            ))
        ) {
            if viewModel.selectedCategory != nil {
                viewModel.updateCategory(subscriptionID: subscriptionId)
            }
        }
    }
    
}

// MARK: - Preview
#Preview {
    SubscriptionDetailView(subscriptionId: 0)
}
