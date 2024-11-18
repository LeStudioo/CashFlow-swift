//
//  TabBarItem.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI

struct TabBarItem: View {
    
    // Builder
    var icon: String
    var title: String
    var tag: Int
    
    @EnvironmentObject private var appManager: AppManager
    
    // MARK: -
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "\(icon)\(appManager.selectedTab == tag ? ".fill" : "")")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .frame(width: 20, height: 20)
            
            Text(title)
                .font(.semiBoldSmall())
        }
        .foregroundStyle(
            appManager.selectedTab == tag
            ? Color(uiColor: UIColor.label)
            : Color.reversedCustomGray
        )
        .onTapGesture { selectTab(tag) }
        .frame(maxWidth: .infinity)
    } // body
    
    // MARK: - Functions
    func selectTab(_ tab: Int) {
        appManager.selectedTab = tab
        appManager.menuIsPresented = false
    }
} // struct

// MARK: - Preview
#Preview {
    TabBarItem(
        icon: "house",
        title: "word_home",
        tag: 0
    )
}
