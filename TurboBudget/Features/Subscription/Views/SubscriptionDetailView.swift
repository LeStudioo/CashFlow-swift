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
            ScrollView(.vertical) {
                VStack(spacing: 32) {
                    VStack(spacing: 4) {
                        Text("\(subscription.symbol) \(subscription.amount.toCurrency())")
                            .font(.system(size: 48, weight: .heavy))
                            .foregroundColor(subscription.color)
                        
                        Text(subscription.name)
                            .font(DesignSystem.FontDS.Title.semibold)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            DetailRow(
                                icon: "clock.arrow.circlepath",
                                text: Word.Classic.frequency,
                                value: subscription.frequency.name
                            )
                            
                            DetailRow(
                                icon: "calendar",
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
                                    icon: "calendar",
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
                                            .padding(.bottom, 12)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 32)
            } // ScrollView
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarDismissPushButton()
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
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
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.text)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                    }
                }
                
                ToolbarDismissKeyboardButtonView()
            }
            .background(Color.background.edgesIgnoringSafeArea(.all))
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
