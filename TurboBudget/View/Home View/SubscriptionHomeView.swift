//
//  SubscriptionHomeView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

struct SubscriptionHomeView: View {
    
    // Environement
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var subscriptionRepository: SubscriptionRepository
    @Environment(\.dismiss) private var dismiss
    
    // State or Binding Orientation
    @State private var orientation = UIDeviceOrientation.unknown
    
    // MARK: - body
    var body: some View {
        VStack(spacing: 0) {
            if !subscriptionRepository.subscriptions.isEmpty {
                List {
                    ForEach(subscriptionRepository.subscriptionsByMonth.sorted(by: { $0.key < $1.key }), id: \.key) { month, subscriptions in
                        Section {
                            ForEach(subscriptions, id: \.self) { subscription in
                                SubscriptionRow(subscription: subscription)
                                    .padding(.horizontal)
                            }
                        } header: {
                            DetailOfExpensesAndIncomesByMonth(
                                month: month,
                                amountOfExpenses: subscriptionRepository.amountExpensesByMonth(month: month),
                                amountOfIncomes: subscriptionRepository.amountIncomesByMonth(month: month)
                            )
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                    .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
                } // End List
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(Color.background.edgesIgnoringSafeArea(.all))
                .animation(.smooth, value: subscriptionRepository.subscriptions.count)
            }
        }
        .navigationTitle(Word.Classic.subscription.localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
//        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationButton(present: router.presentCreateSubscription()) {
                    Image(systemName: "plus")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onAppear { getOrientationOnAppear() }
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
    SubscriptionHomeView()
}
