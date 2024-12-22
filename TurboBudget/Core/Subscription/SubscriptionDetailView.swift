//
//  SubscriptionDetailView.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/12/2024.
//

import SwiftUI
import AlertKit

struct SubscriptionDetailView: View {
    
    // Builder
    @ObservedObject var subscription: SubscriptionModel
    
    // Custom type
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var alertManager: AlertManager
    @StateObject var viewModel: SubscriptionDetailViewModel = .init()
    
    // Environement
    @Environment(\.dismiss) private var dismiss
    
    // MARK: -
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("\(subscription.symbol) \(subscription.amount?.toCurrency() ?? "")")
                        .font(.system(size: 48, weight: .heavy))
                        .foregroundColor(subscription.color)
                    
                    Text(subscription.name ?? "")
                        .font(.semiBoldH3())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                
                VStack(spacing: 12) {
                    DetailRow(
                        icon: "clock.arrow.circlepath",
                        text: Word.Classic.frequency,
                        value: subscription.frequency?.name ?? ""
                    )
                    
                    DetailRow(
                        icon: "calendar",
                        text: "transaction_detail_date".localized,
                        value: subscription.date.formatted(date: .complete, time: .omitted).capitalized
                    )
                    
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
                Menu(content: {
                    Button(
                        action: { router.presentCreateSubscription(subscription: subscription) },
                        label: { Label(Word.Classic.edit, systemImage: "pencil") }
                    )
                    Button(
                        role: .destructive,
                        action: { alertManager.deleteSubscription(subscription: subscription, dismissAction: dismiss) },
                        label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
                    )
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }

            ToolbarDismissKeyboardButtonView()
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Utils
extension SubscriptionDetailView {

    func presentChangeCategory() {
        router.presentSelectCategory(
            category: $viewModel.selectedCategory,
            subcategory: $viewModel.selectedSubcategory
        ) {
            if let subscriptionID = subscription.id, viewModel.selectedCategory != nil {
                viewModel.updateCategory(subscriptionID: subscriptionID)
            }
        }
    }
    
}

// MARK: - Preview
#Preview {
    SubscriptionDetailView(subscription: .mockClassicSubscriptionExpense)
}
