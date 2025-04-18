//
//  PremiumButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI
import NavigationKit

struct PremiumButton: View {
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        NavigationButton(
            route: .sheet,
            destination: AppDestination.shared(.paywall)
        ) {
            HStack(spacing: 4) {
                Text("Pro")
                    .font(.semiBoldText16())
                Image(systemName: "crown.fill")
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .foregroundStyle(Color.white)
            .background {
                Capsule()
                    .fill(themeManager.theme.color)
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    PremiumButton()
        .environmentObject(ThemeManager())
}
