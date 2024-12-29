//
//  CustomTabBar.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import AlertKit

struct CustomTabBar: View {
    
    // Repo
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountStore
    @EnvironmentObject private var creditCardRepository: CreditCardStore
    @EnvironmentObject private var store: PurchasesManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var successfullModalManager: SuccessfullModalManager
    
    // Custom type
    @ObservedObject var viewModel = CustomTabBarViewModel.shared

    // Environement
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var offsetYMenu: CGFloat = 0

    // MARK: -
    var body: some View {
        ZStack(alignment: .top) {
            TabBarShape()
                .foregroundStyle(colorScheme == .light ? .primary0 : .secondary500)
                .cornerRadius(10, corners: .topLeft)
                .cornerRadius(10, corners: .topRight)
                .frame(height: 100)
                .shadow(radius: 64, y: -3)
            
            TabBarContent()
            
            ZStack {
                Circle()
                    .foregroundStyle(themeManager.theme.color)
                    .frame(width: 80)
                
                Image(systemName: "plus")
                    .font(.system(size: 34, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.textReversed)
            }
            .frame(height: 80)
            .offset(y: -10)
            .onTapGesture {
                withAnimation(.smooth) {
                    viewModel.showMenu.toggle()
                    VibrationManager.vibration()
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CustomTabBar()
    
    TabBarShape()
        .cornerRadius(15, corners: [.topLeft, .topRight])
        .frame(width: UIScreen.main.bounds.width, height: 100)
        .padding()
}
