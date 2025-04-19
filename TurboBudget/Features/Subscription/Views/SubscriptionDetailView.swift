//
//  SubscriptionDetailView.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/12/2024.
//

import SwiftUI
import AlertKit
import NavigationKit

struct SubscriptionDetailView: View {
    
    // Builder
    var subscription: SubscriptionModel
    
    // Custom type
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var subscriptionStore: SubscriptionStore
    @StateObject var viewModel: SubscriptionDetailViewModel = .init()
    
    // Environement
    @Environment(\.dismiss) private var dismiss
    
    var currentSubscription: SubscriptionModel {
        return subscriptionStore.subscriptions.first { $0.id == subscription.id } ?? subscription
    }
    
    // MARK: -
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("\(currentSubscription.symbol) \(currentSubscription.amount?.toCurrency() ?? "")")
                        .font(.system(size: 48, weight: .heavy))
                        .foregroundColor(currentSubscription.color)
                    
                    Text(currentSubscription.name ?? "")
                        .font(DesignSystem.FontDS.Title.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                
                VStack(spacing: 12) {
                    DetailRow(
                        icon: "clock.arrow.circlepath",
                        text: Word.Classic.frequency,
                        value: currentSubscription.frequency?.name ?? ""
                    )
                    
                    DetailRow(
                        icon: "calendar",
                        text: "transaction_detail_date".localized,
                        value: currentSubscription.date.formatted(date: .complete, time: .omitted).capitalized
                    )
                    
                    if let category = currentSubscription.category {
                        DetailRow(
                            icon: category.icon,
                            value: category.name,
                            iconBackgroundColor: category.color) {
                                presentChangeCategory()
                            }
                        
                        if let subcategory = currentSubscription.subcategory {
                            DetailRow(
                                icon: subcategory.icon,
                                value: subcategory.name,
                                iconBackgroundColor: subcategory.color) {
                                    presentChangeCategory()
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
                        route: .sheet,
                        destination: AppDestination.subscription(.update(subscription: currentSubscription))
                    ) {
                        Label(Word.Classic.edit, systemImage: "pencil")
                    }
                    Button(
                        role: .destructive,
                        action: { AlertManager.shared.deleteSubscription(subscription: currentSubscription, dismissAction: dismiss) },
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
            if let subscriptionID = currentSubscription.id, viewModel.selectedCategory != nil {
                viewModel.updateCategory(subscriptionID: subscriptionID)
            }
        }
    }
    
}

// MARK: - Preview
#Preview {
    SubscriptionDetailView(subscription: .mockClassicSubscriptionExpense)
}
