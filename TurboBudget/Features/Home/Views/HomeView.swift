//
//  HomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 01/10/2023
// Refactor 18/02/2024

import SwiftUI
import CoreData
import StoreKit
import NavigationKit

struct HomeView: View {
        
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var purchasesManager: PurchasesManager
    
    @StateObject private var preferencesGeneral: PreferencesGeneral = .shared
    
    // Environment
    @Environment(\.requestReview) private var requestReview
    
    // MARK: -
    var body: some View {
        VStack(spacing: 16) {
            HomeHeader()
                .padding(.horizontal)
            
            ScrollView {
                CarouselOfChartsView()
                    .padding(.bottom, 24)
                
                VStack(spacing: 32) {
                    HomeScreenSubscription()
                    HomeScreenRecentTransactions()
                    HomeScreenSavingsPlan()
                }
                .padding(.horizontal)
                
                Rectangle()
                    .frame(height: 120)
                    .opacity(0)
            } // ScrollView
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onAppear {
            preferencesGeneral.numberOfOpenings += 1
            if (preferencesGeneral.numberOfOpenings % 6 == 0) && !preferencesGeneral.isApplePayEnabled {
                router.present(route: .modalFitContent, .tips(.applePayShortcut))
            }
            if preferencesGeneral.numberOfOpenings > 8 && !preferencesGeneral.isReviewPopupPresented {
                Task { @MainActor in
                    preferencesGeneral.isReviewPopupPresented = true
                    requestReview()
                }
            }
            if preferencesGeneral.numberOfOpenings % 20 == 0 && !purchasesManager.isCashFlowPro {
                router.present(route: .sheet, .shared(.paywall))
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeView()
}
