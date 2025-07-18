//
//  NoInternetView.swift
//  CashFlow
//
//  Created by Theo Sementa on 19/04/2025.
//

import SwiftUI

struct NoInternetView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            Image("NoInternet" + themeManager.theme.nameNotLocalized.capitalized)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 4, y: 4)
                .frame(width: UIScreen.main.bounds.width / (UIDevice.isIpad ? 3 : 1.5))
            
            Text("OOPS...")
                .font(.Subtitle.medium)
            
            Text("no_internet_description".localized)
                .font(.Text.medium)
                .multilineTextAlignment(.center)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    NoInternetView()
        .environmentObject(ThemeManager.shared)
}
