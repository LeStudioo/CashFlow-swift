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
    @EnvironmentObject private var subscriptionRepository: SubscriptionRepository
    @EnvironmentObject private var automationRepo: AutomationRepositoryOld
    
    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared
    
    // MARK: -
    var body: some View {
        VStack {
            HomeScreenComponentHeader(type: .subscription)
            
            if !subscriptionRepository.subscriptions.isEmpty {
                VStack {
                    ForEach(subscriptionRepository.subscriptions.prefix(preferencesDisplayHome.subscription_value)) { subscription in
                        Button(action: {
//                            if let transaction = automation.automationToTransaction {
//                                router.pushTransactionDetail(transaction: transaction)
//                            }
                        }, label: {
                            AutomationRow(subscription: subscription)
                        })
                    }
                }
            } else {
                HomeScreenEmptyRow(type: .subscription)
            }
        }
        .isDisplayed(preferencesDisplayHome.subscription_isDisplayed)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    HomeScreenSubscription()
}
