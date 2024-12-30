//
//  MenuCreationView.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/12/2024.
//

import SwiftUI
import AlertKit

struct MenuCreationView: View {
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountStore
    @EnvironmentObject private var creditCardRepository: CreditCardStore
    
    @EnvironmentObject private var store: PurchasesManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var appManager: AppManager

    @State private var isQrCodeScannerPresented: Bool = false
    @State private var identityToken: String = ""
    
    private var menuActions: [MenuCreationAction] {
        if accountRepository.mainAccount != nil {
            return [
                MenuCreationAction(
                    title: Word.Main.creditCard,
                    icon: "creditcard.fill",
                    present: { router.presentCreateCreditCard() },
                    isDisabled: !store.isCashFlowPro || !creditCardRepository.creditCards.isEmpty,
                    onTapAction: {
                        if !store.isCashFlowPro {
                            alertManager.showPaywall(router: router)
                        } else if !creditCardRepository.creditCards.isEmpty {
                            alertManager.onlyOneCreditCardByAccount()
                        }
                    }
                ),
                MenuCreationAction(
                    title: Word.Main.savingsAccount,
                    icon: "building.columns",
                    present: { router.presentCreateAccount(type: .savings) },
                    isDisabled: !accountRepository.savingsAccounts.isEmpty && !store.isCashFlowPro,
                    onTapAction: {
                        if !accountRepository.savingsAccounts.isEmpty && !store.isCashFlowPro {
                            alertManager.showPaywall(router: router)
                        }
                    }
                ),
                MenuCreationAction(
                    title: Word.Main.transfer,
                    icon: "arrow.left.arrow.right",
                    present: { router.presentCreateTransfer() }
                ),
                MenuCreationAction(
                    title: Word.Main.savingsPlan,
                    icon: "dollarsign.square.fill",
                    present: { router.presentCreateSavingsPlan() }
                ),
                MenuCreationAction(
                    title: Word.Classic.budget,
                    icon: "chart.pie.fill",
                    present: { router.presentCreateBudget() },
                    isDisabled: !store.isCashFlowPro,
                    onTapAction: {
                        if !store.isCashFlowPro {
                            alertManager.showPaywall(router: router)
                        }
                    }
                ),
                MenuCreationAction(
                    title: Word.Main.subscription,
                    icon: "clock.arrow.circlepath",
                    present: { router.presentCreateSubscription() }
                ),
                MenuCreationAction(
                    title: Word.Main.transaction,
                    icon: "creditcard.and.123",
                    present: { router.presentCreateTransaction() }
                )
            ]
        } else {
            return [
                MenuCreationAction(
                    title: "word_account".localized,
                    icon: "person",
                    present: { router.presentCreateAccount(type: .classic) }
                )
            ]
        }
    }
    
    // MARK: -
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 40) {
                ForEach(menuActions) { action in
                    MenuCreationButton(action: action) {
                        onPress()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(Color.text)
            .padding()
            .padding([.top, .leading])
            
            Spacer()
            
            Button {
                withAnimation(.smooth) {
                    appManager.isMenuPresented = false
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
        .sheet(isPresented: $isQrCodeScannerPresented) {
            QRCodeScannerView(identityToken: $identityToken)
        }
    } // body
    
    private func onPress() {
        appManager.isMenuPresented = false
        VibrationManager.vibration()
    }
    
} // struct

// MARK: - Preview
#Preview {
    MenuCreationView()
}
