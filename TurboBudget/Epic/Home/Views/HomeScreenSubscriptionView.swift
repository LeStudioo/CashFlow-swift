//
//  HomeScreenSubscriptionView.swift
//  CashFlow
//
//  Created by KaayZenn on 21/07/2023.
//
// Localizations 01/10/2023
// Refactor 25/02/2024

import SwiftUI
import NavigationKit
import TheoKit
import DesignSystemModule
import PreferencesModule

struct HomeScreenSubscriptionView: View {
    
    // Environment
    @EnvironmentObject private var subscriptionStore: SubscriptionStore
    
    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared
    
    // MARK: -
    var body: some View {
        VStack(spacing: Spacing.standard) {
            HomeScreenComponentHeaderView(type: .subscription)
            
            if !subscriptionStore.subscriptions.isEmpty {
                VStack(spacing: Spacing.medium) {
                    ForEach(subscriptionStore.subscriptions.prefix(preferencesDisplayHome.subscription_value)) { subscription in
                        NavigationButton(
                            route: .push,
                            destination: AppDestination.subscription(.detail(subscriptionId: subscription.id))
                        ) {
                            SubscriptionRowView(subscription: subscription)
                        }
                    }
                }
            } else {
                CustomEmptyView(
                    type: .empty(.subscriptions(.home)),
                    isDisplayed: true
                )
            }
        }
        .isDisplayed(preferencesDisplayHome.subscription_isDisplayed)
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeScreenSubscriptionView()
}
