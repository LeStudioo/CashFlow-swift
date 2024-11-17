//
//  TabbarView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 30/09/2023


import SwiftUI

struct TabbarView: View {
    
    // Builder
    @Binding var selectedTab: Int
    
    // Repo
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountRepository
    
    @EnvironmentObject private var successfullModalManager: SuccessfullModalManager
    
    // Custom type
    @ObservedObject var filter: Filter = sharedFilter
    @ObservedObject var viewModel = CustomTabBarViewModel.shared

    // Environement
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var offsetYMenu: CGFloat = 0

    // MARK: -
    var body: some View {
        ZStack(alignment: .top) {
            TabbarShape()
                .foregroundStyle(colorScheme == .light ? .primary0 : .secondary500)
                .cornerRadius(10, corners: .topLeft)
                .cornerRadius(10, corners: .topRight)
                .frame(height: 100)
                .shadow(radius: 64, y: -3)
            
            ItemsForTabBar(selectedTab: $selectedTab, showMenu: $viewModel.showMenu)
            
            ZStack {
                VStack(alignment: .leading, spacing: 32) {
                    if accountRepository.mainAccount != nil {
                        NavigationButton(present: router.presentCreateSavingsPlan()) {
                            viewModel.showMenu = false
                        } label: {
                            Label("word_savingsplan".localized, systemImage: "dollarsign.square.fill")
                        }
                        
                        NavigationButton(present: router.presentRecoverTransaction()) {
                            viewModel.showMenu = false
                        } label: {
                            Label("recover_button".localized, systemImage: "tray.and.arrow.down.fill")
                        }
                        
                        NavigationButton(present: router.presentCreateAutomation()) {
                            viewModel.showMenu = false
                        } label: {
                            Label("word_automation".localized, systemImage: "clock.arrow.circlepath")
                        }
                        
                        Button(action: { withAnimation { viewModel.showScanTransactionSheet() } }, label: {
                            Label("word_scanner".localized, systemImage: "barcode.viewfinder")
                        })
                        
                        NavigationButton(present: router.presentCreateTransaction()) {
                            viewModel.showMenu = false
                        } label: {
                            Label("word_transaction".localized, systemImage: "creditcard.and.123")
                        }
                    } else {
                        NavigationButton(present: router.presentCreateAccount()) {
                            viewModel.showMenu = false
                        } label: {
                            Label("word_account".localized, systemImage: "person")
                        }
                    }
                }
                .foregroundStyle(Color.label)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(colorScheme == .light ? Color.primary0 : Color.secondary500)
                        .shadow(radius: 4)
                }
                .scaleEffect(viewModel.showMenu ? 1 : 0)
                .offset(y: offsetYMenu)
                .opacity(viewModel.showMenu ? 1 : 0)
                
                Circle()
                    .foregroundStyle(ThemeManager.theme.color)
                    .frame(width: 80)
                
                Image(systemName: "plus")
                    .font(.system(size: 34, weight: .regular, design: .rounded))
                    .foregroundStyle(colorScheme == .light ? .primary0 : .secondary500)
                    .rotationEffect(.degrees(viewModel.showMenu ? 45 : 0))
            }
            .frame(height: 80)
            .offset(y: -10)
            .animation(.interpolatingSpring(stiffness: 150, damping: 12), value: viewModel.showMenu)
            .animation(.interpolatingSpring(stiffness: 150, damping: 12), value: offsetYMenu)
            .onTapGesture {
                filter.showMenu = false
                viewModel.showMenu.toggle()
            }
            .onChange(of: viewModel.showMenu) { newValue in
                if newValue {
                    if accountRepository.mainAccount != nil {
                        offsetYMenu = -180
                    } else { offsetYMenu = -80 }
                } else {
                    offsetYMenu = 0
                }
                if viewModel.showMenu {
                    VibrationManager.vibration()
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    TabbarView(selectedTab: .constant(0))
    
    TabbarShape()
        .cornerRadius(15, corners: [.topLeft, .topRight])
        .frame(width: UIScreen.main.bounds.width, height: 100)
        .padding()
}
