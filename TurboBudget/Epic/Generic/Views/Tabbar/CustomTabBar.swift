//
//  CustomTabBar.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import AlertKit
import DesignSystemModule
import CoreModule

struct CustomTabBar: View {
    
    // Repo
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var creditCardStore: CreditCardStore
    
    @EnvironmentObject private var store: PurchasesManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var appManager: AppManager
    @EnvironmentObject private var successfullModalManager: SuccessfullModalManager
    
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
                    appManager.isMenuPresented.toggle()
                    VibrationManager.vibration()
                }
            }
        }
    } // bodyTr
} // struct

// MARK: - Preview
#Preview {
    CustomTabBar()
    
    TabBarShape()
        .cornerRadius(15, corners: [.topLeft, .topRight])
        .frame(width: UIScreen.main.bounds.width, height: 100)
        .padding()
}
