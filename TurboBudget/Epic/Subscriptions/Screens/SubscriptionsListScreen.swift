//
//  SubscriptionHomeView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import NavigationKit
import StatsKit
import TheoKit

struct SubscriptionsListScreen: View {
    
    // Environement
    @EnvironmentObject private var subscriptionStore: SubscriptionStore
    @EnvironmentObject private var router: Router<AppDestination>
    @Environment(\.dismiss) private var dismiss
    
    // State or Binding Orientation
    @State private var orientation = UIDeviceOrientation.unknown
    
    // MARK: -
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(
                title: Word.Main.subscriptions.localized,
                actionButton: .init(
                    title: Word.Classic.create,
                    action: { router.push(.subscription(.create)) },
                    isDisabled: false
                )
            )
            
            List {
                ForEach(subscriptionStore.subscriptionsByMonth.sorted(by: { $0.key < $1.key }), id: \.key) { month, subscriptions in
                    Section {
                        ForEach(subscriptions, id: \.self) { subscription in
                            NavigationButton(
                                route: .push,
                                destination: AppDestination.subscription(.detail(subscriptionId: subscription.id))
                            ) {
                                SubscriptionRowView(subscription: subscription)
                            }
                            .padding(.bottom, TKDesignSystem.Padding.medium)
                            .padding(.horizontal, TKDesignSystem.Padding.large)
                        }
                    } header: {
                        DetailOfExpensesAndIncomesByMonth(
                            month: month,
                            amountOfExpenses: subscriptionStore.amountExpensesByMonth(month: month),
                            amountOfIncomes: subscriptionStore.amountIncomesByMonth(month: month)
                        )
                        .padding(.horizontal, TKDesignSystem.Padding.large)
                    }
                }
                .noDefaultStyle()
            } // End List
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
        }
        .background(TKDesignSystem.Colors.Background.Theme.bg50.ignoresSafeArea(.all))
        .animation(.smooth, value: subscriptionStore.subscriptions.count)
        .overlay {
            CustomEmptyView(
                type: .empty(.subscriptions(.list)),
                isDisplayed: subscriptionStore.subscriptions.isEmpty
            )
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onAppear {
            getOrientationOnAppear()
            EventService.sendEvent(key: .subscriptionDetailPage)
        }
    } // End body
    
    // MARK: - Fonctions
    func getOrientationOnAppear() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            orientation = UIDeviceOrientation.landscapeLeft
        } else { orientation = UIDeviceOrientation.portrait }
    }
    
} // End struct

// MARK: - Preview
#Preview {
    SubscriptionsListScreen()
}
