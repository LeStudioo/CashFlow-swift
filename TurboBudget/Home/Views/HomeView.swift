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

struct HomeView: View {
        
    @EnvironmentObject private var modalManager: ModalManager
    @EnvironmentObject private var router: NavigationManager
    
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
                
                VStack(spacing: 24) {
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
                modalManager.presentTipApplePayShortcut()
            }
            if preferencesGeneral.numberOfOpenings > 8 && !preferencesGeneral.isReviewPopupPresented {
                Task { @MainActor in
                    preferencesGeneral.isReviewPopupPresented = true
                    requestReview()
                }
            }
            if preferencesGeneral.numberOfOpenings % 20 == 0 {
                router.presentPaywall()
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeView()
}
