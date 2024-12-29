//
//  CreationSelectionView.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/12/2024.
//

import SwiftUI
import AlertKit

struct CreationSelectionView: View {
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountStore
    @EnvironmentObject private var creditCardRepository: CreditCardStore
    
    @EnvironmentObject private var store: PurchasesManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var alertManager: AlertManager
    
    @ObservedObject var viewModel = CustomTabBarViewModel.shared

    // MARK: -
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 40) {
                if accountRepository.mainAccount != nil {
                    NavigationButton(present: router.presentCreateCreditCard()) { onPress() } label: {
                        Label(Word.Main.creditCard, systemImage: "creditcard.fill")
                    }
                    .disabled(!store.isCashFlowPro || !creditCardRepository.creditCards.isEmpty)
                    .onTapGesture {
                        if !store.isCashFlowPro {
                            alertManager.showPaywall(router: router)
                        } else if !creditCardRepository.creditCards.isEmpty {
                            alertManager.onlyOneCreditCardByAccount()
                        }
                    }
                    
                    NavigationButton(present: router.presentCreateAccount(type: .savings)) { onPress() } label: {
                        Label(Word.Main.savingsAccount, systemImage: "building.columns")
                    }
                    .disabled(!accountRepository.savingsAccounts.isEmpty && !store.isCashFlowPro)
                    .onTapGesture {
                        if !accountRepository.savingsAccounts.isEmpty && !store.isCashFlowPro {
                            alertManager.showPaywall(router: router)
                        }
                    }
                    
                    NavigationButton(present: router.presentCreateTransfer()) { onPress() } label: {
                        Label(Word.Main.transfer, systemImage: "arrow.left.arrow.right")
                    }
                    
                    NavigationButton(present: router.presentCreateSavingsPlan()) { onPress() } label: {
                        Label(Word.Main.savingsPlan, systemImage: "dollarsign.square.fill")
                    }
                    
                    NavigationButton(present: router.presentCreateBudget()) { onPress() } label: {
                        Label(Word.Classic.budget, systemImage: "chart.pie.fill")
                    }
                    .disabled(!store.isCashFlowPro)
                    .onTapGesture {
                        if !store.isCashFlowPro {
                            alertManager.showPaywall(router: router)
                        }
                    }
                    
                    NavigationButton(present: router.presentCreateSubscription()) { onPress() } label: {
                        Label(Word.Main.subscription, systemImage: "clock.arrow.circlepath")
                    }
                    
                    NavigationButton(present: router.presentCreateTransaction()) { onPress() } label: {
                        Label(Word.Main.transaction, systemImage: "creditcard.and.123")
                            
                    }
                } else {
                    NavigationButton(present: router.presentCreateAccount(type: .classic)) {
                        viewModel.showMenu = false
                        VibrationManager.vibration()
                    } label: {
                        Label("word_account".localized, systemImage: "person")
                    }
                }
            }
            .font(.Button.text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(Color.text)
            .padding()
            .padding([.top, .leading])
            
            Spacer()
            
            Button {
                withAnimation(.smooth) {
                    viewModel.showMenu = false
                    VibrationManager.vibration()
                }
            } label: {
                Circle()
                    .foregroundStyle(themeManager.theme.color)
                    .frame(width: 80)
                    .overlay {
                        Image(systemName: "xmark")
                            .font(.system(size: 30, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.textReversed)
                    }
            }
            .offset(y: -30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.white
                .opacity(0.1)
                .blur(radius: 10)
        )
    } // body
    
    private func onPress() {
        viewModel.showMenu = false
        VibrationManager.vibration()
    }
    
} // struct

// MARK: - Preview
#Preview {
    CreationSelectionView()
}
