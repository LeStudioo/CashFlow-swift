//
//  CreationMenuView.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/12/2024.
//

import SwiftUI
import AlertKit
import NavigationKit

struct CreationMenuView: View {
    
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var creditCardStore: CreditCardStore
    
    @EnvironmentObject private var store: PurchasesManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var appManager: AppManager

    @State private var isPresented: Bool = false
    
    var router: Router<AppDestination>? {
        return AppRouterManager.shared.router(for: .home)
    }
    
    private var menuActions: [CreationMenuAction] {
        if let router, accountStore.selectedAccount != nil {
            var actions: [CreationMenuAction] = [
                CreationMenuAction(
                    title: Word.Main.creditCard,
                    icon: "creditcard.fill",
                    destination: .creditCard(.create),
                    isDisabled: !store.isCashFlowPro || !creditCardStore.creditCards.isEmpty,
                    onTapAction: {
                        if !store.isCashFlowPro {
                            alertManager.showPaywall(router: router)
                        } else if !creditCardStore.creditCards.isEmpty {
                            alertManager.onlyOneCreditCardByAccount()
                        }
                    }
                ),
                CreationMenuAction(
                    title: Word.Main.savingsAccount,
                    icon: "building.columns",
                    destination: .savingsAccount(.create),
                    isDisabled: !accountStore.savingsAccounts.isEmpty && !store.isCashFlowPro,
                    onTapAction: {
                        if !accountStore.savingsAccounts.isEmpty && !store.isCashFlowPro {
                            alertManager.showPaywall(router: router)
                        }
                    }
                ),
                CreationMenuAction(
                    title: "word_account".localized,
                    icon: "person",
                    destination: .account(.create)
                ),
                CreationMenuAction(
                    title: Word.Main.transfer,
                    icon: "arrow.left.arrow.right",
                    destination: .transfer(.create())
                ),
                CreationMenuAction(
                    title: Word.Main.savingsPlan,
                    icon: "dollarsign.square.fill",
                    destination: .savingsPlan(.create)
                ),
                CreationMenuAction(
                    title: Word.Classic.budget,
                    icon: "chart.pie.fill",
                    destination: .budget(.create),
                    isDisabled: !store.isCashFlowPro,
                    onTapAction: {
                        if !store.isCashFlowPro {
                            alertManager.showPaywall(router: router)
                        }
                    }
                ),
                CreationMenuAction(
                    title: Word.Main.subscription,
                    icon: "clock.arrow.circlepath",
                    destination: .subscription(.create)
                ),
                CreationMenuAction(
                    title: Word.Main.transaction,
                    icon: "creditcard.and.123",
                    destination: .transaction(.create)
                )
            ]
            
            #if DEBUG
            actions.append(
                CreationMenuAction(
                    title: "TBL Scan QRCode",
                    icon: "qrcode",
                    destination: .shared(.qrCodeScanner)
                )
            )
            #endif
            
            return actions
        } else {
            return [
                CreationMenuAction(
                    title: "word_account".localized,
                    icon: "person",
                    destination: .account(.create)
                )
            ]
        }
    }
    
    // MARK: -
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 40) {
                ForEach(Array(menuActions.enumerated()), id: \.offset) { index, action in
                    CreationMenuButton(action: action) {
                        appManager.isMenuPresented = false
                        VibrationManager.vibration()
                    }
                    .offset(y: isPresented ? 0 : 50)
                    .opacity(isPresented ? 1 : 0)
                    .animation(
                        .spring(response: 0.3)
                        .delay(Double(index) * 0.1),
                        value: isPresented
                    )
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
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.white
                .opacity(0.1)
                .blur(radius: 10)
        )
        .onAppear {
            isPresented = true
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CreationMenuView()
}
