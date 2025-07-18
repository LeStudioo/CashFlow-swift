//
//  TabBarItem.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI
import TheoKit

struct TabBarItem: View {
    
    // Builder
    var icon: ImageResource
    var title: String
    var tag: Int
    
    @EnvironmentObject private var appManager: AppManager
    
    // MARK: -
    var body: some View {
        Button(action: { selectTab(tag) }, label: {
            VStack(spacing: 14) {
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 22, height: 22)
                
                Text(title)
                    .fontWithLineHeight(.Label.large)
            }
            .foregroundStyle(
                appManager.selectedTab == tag
                ? Color.label
                : TKDesignSystem.Colors.Background.Theme.bg500
            )
        })
//        .frame(maxWidth: .infinity)
        .buttonStyle(BouncyButtonStyle())
    } // body
    
    // MARK: - Functions
    func selectTab(_ tab: Int) {
        appManager.selectedTab = tab
        appManager.isMenuPresented = false
        VibrationManager.vibration()
    }
} // struct

// MARK: - Preview
#Preview {
    TabBarItem(
        icon: .iconHouse,
        title: "word_home",
        tag: 0
    )
}
