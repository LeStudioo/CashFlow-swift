//
//  SettingsAppearenceView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI

struct SettingsAppearenceView: View {
                
    // MARK: -
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ThemeCell(type: .system)
                    ThemeCell(type: .light)
                    ThemeCell(type: .dark)
                }
                
                SelectThemeColor()
                
                SelectAppIcon()
            }
            .padding()
        } // ScrollView
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .background(Color.background)
        .navigationBarTitleDisplayMode(.inline)
    } // body
} // struct

// MARK: - Preview
#Preview {
    SettingsAppearenceView()
        .environmentObject(AppearanceManager())
        .environmentObject(ThemeManager())
}
