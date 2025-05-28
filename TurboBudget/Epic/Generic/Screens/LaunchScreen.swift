//
//  LaunchScreen.swift
//  CashFlow
//
//  Created by Théo Sementa on 11/07/2023.
//
// Refactor -> 17/02/2024

import SwiftUI

struct LaunchScreen: View {
    
    // Builder
    @Binding var launchScreenEnd: Bool
        
    // MARK: - body
    var body: some View {
        Image(UIDevice.isIpad ? "LaunchScreenIPad" : "LaunchScreen")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea([.bottom, .top])
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { withAnimation { launchScreenEnd = true } }
            }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    LaunchScreen(launchScreenEnd: .constant(false))
}
