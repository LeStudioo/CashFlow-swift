//
//  HomeScreenSubscription.swift
//  CashFlow
//
//  Created by KaayZenn on 21/07/2023.
//
// Localizations 01/10/2023
// Refactor 25/02/2024

import SwiftUI

struct HomeScreenSubscription: View {
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var subscriptionStore: SubscriptionStore
    @EnvironmentObject private var automationRepo: AutomationRepositoryOld
    
    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared
    
    // MARK: -
    var body: some View {
        VStack {
            HomeScreenComponentHeader(type: .subscription)
            
            if !subscriptionStore.subscriptions.isEmpty {
                VStack {
                    ForEach(subscriptionStore.subscriptions.prefix(preferencesDisplayHome.subscription_value)) { subscription in
                        NavigationButton(push: router.pushSubscriptionDetail(subscription: subscription)) {
                            SubscriptionRow(subscription: subscription)
                        }
                    }
                }
            } else {
                HomeScreenEmptyRow(type: .subscription)
            }
        }
        .isDisplayed(preferencesDisplayHome.subscription_isDisplayed)
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeScreenSubscription()
}
