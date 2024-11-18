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
                    .padding(.bottom)
                
                VStack(spacing: 16) {
                    HomeScreenSavingsPlan()
                    HomeScreenSubscription()
                    HomeScreenRecentTransactions()
                }
                .padding(.horizontal)
                
                Rectangle()
                    .frame(height: 100)
                    .opacity(0)
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
