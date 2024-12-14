//
//  CustomTabBar.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 30/09/2023


import SwiftUI

struct CustomTabBar: View {
    
    // Repo
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountRepository
    @EnvironmentObject private var creditCardRepository: CreditCardRepository
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
                VStack(alignment: .leading, spacing: 32) {
                    if accountRepository.mainAccount != nil {
                        NavigationButton(present: router.presentCreateCreditCard()) {
                            viewModel.showMenu = false
                        } label: {
                            Label(Word.Main.creditCard, systemImage: "creditcard.fill")
                        }
                        .disabled(!store.isCashFlowPro || !creditCardRepository.creditCards.isEmpty)
                        .onTapGesture {
                            if !store.isCashFlowPro {
                                alertManager.showPaywall()
                            } else if !creditCardRepository.creditCards.isEmpty {
                                alertManager.onlyOneCreditCardByAccount()
                            }
                        }
                        
                        NavigationButton(present: router.presentCreateAccount(type: .savings)) {
                            viewModel.showMenu = false
                        } label: {
                            Label(Word.Main.savingsAccount, systemImage: "building.columns")
                        }
                        .disabled(!accountRepository.savingsAccounts.isEmpty && !store.isCashFlowPro)
                        .onTapGesture {
                            if !accountRepository.savingsAccounts.isEmpty && !store.isCashFlowPro {
                                alertManager.showPaywall()
                            }
                        }
                        
                        NavigationButton(present: router.presentCreateTransfer()) {
                            viewModel.showMenu = false
                        } label: {
                            Label(Word.Main.transfer, systemImage: "arrow.left.arrow.right")
                        }
                        
                        NavigationButton(present: router.presentCreateSavingsPlan()) {
                            viewModel.showMenu = false
                        } label: {
                            Label(Word.Main.savingsPlan, systemImage: "dollarsign.square.fill")
                        }
                        
                        NavigationButton(present: router.presentCreateBudget()) {
                            viewModel.showMenu = false
                        } label: {
                            Label(Word.Classic.budget, systemImage: "chart.pie.fill")
                        }
                        .disabled(!store.isCashFlowPro)
                        .onTapGesture {
                            if !store.isCashFlowPro {
                                alertManager.showPaywall()
                            }
                        }
                        
                        NavigationButton(present: router.presentCreateSubscription()) {
                            viewModel.showMenu = false
                        } label: {
                            Label(Word.Main.subscription, systemImage: "clock.arrow.circlepath")
                        }
                        
                        NavigationButton(present: router.presentCreateTransaction()) {
                            viewModel.showMenu = false
                        } label: {
                            Label(Word.Main.transaction, systemImage: "creditcard.and.123")
                        }
                    } else {
                        NavigationButton(present: router.presentCreateAccount(type: .classic)) {
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
                    .foregroundStyle(themeManager.theme.color)
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
                viewModel.showMenu.toggle()
            }
            .onChange(of: viewModel.showMenu) { newValue in
                if newValue {
                    if accountRepository.mainAccount != nil {
                        offsetYMenu = -240
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
    CustomTabBar()
    
    TabBarShape()
        .cornerRadius(15, corners: [.topLeft, .topRight])
        .frame(width: UIScreen.main.bounds.width, height: 100)
        .padding()
}
