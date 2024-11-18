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

struct HomeView: View {
    
    // MARK: -
    var body: some View {
        VStack(spacing: 16) {
            HomeHeader()
                .padding(.horizontal)
            
            ScrollView {
                CarouselOfChartsView()
                
                HomeScreenSavingsPlan()
                
                HomeScreenSubscription()
                
                HomeScreenRecentTransactions()
            } // ScrollView
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeView()
}
