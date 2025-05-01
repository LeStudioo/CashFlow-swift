//
//  PaywallView.swift
//  CashFlow
//
//  Created by KaayZenn on 20/08/2023.
//
// Localizations 01/10/2023

import SwiftUI
import StatsKit

struct PaywallView: View {
    
    // EnvironmentObject
    @EnvironmentObject private var store: PurchasesManager
    var isXmarkPresented: Bool = true
    
    @State private var timeRemaining: TimeInterval = 3 * 3600 // 3 hours in seconds
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // MARK: -
    var body: some View {
        NavigationStack {
            PaywallHeader(isXmarkPresented: isXmarkPresented)
                .padding()
            
            ScrollView {
                VStack(spacing: 24) {
                    NavigationLink(destination: {
                        PaywallFeatureDetail(
                            title: "paywall_prediction_title".localized,
                            imageWithout: [],
                            imageWith: ["predictionPaywallDetailled"],
                            desc: "paywall_detailled_prediction".localized
                        )
                        .onAppear { EventService.sendEvent(key: .paywallDetailPrediction) }
                    }, label: {
                        PaywallRow(
                            systemName: "sparkles",
                            title: "paywall_prediction_title".localized,
                            text: "paywall_prediction_desc".localized,
                            color: .red,
                            isDetailed: true
                        )
                    })
                    
                    PaywallRow(
                        systemName: "apple.logo",
                        title: "paywall_item_applepay_title".localized,
                        text: "paywall_item_applepay_description".localized,
                        color: .indigo,
                        isDetailed: false
                    )
                    
                    PaywallRow(
                        systemName: "creditcard.and.123",
                        title: Word.Main.creditCard,
                        text: Word.Paywall.CreditCard.desc,
                        color: .green,
                        isDetailed: false
                    )
                    
                    PaywallRow(
                        systemName: "creditcard.fill",
                        title: "paywall_item_account_title".localized,
                        text: "paywall_item_account_description".localized,
                        color: .orange,
                        isDetailed: false
                    )
                    
                    PaywallRow(
                        systemName: "building.columns.fill",
                        title: Word.Main.savingsAccounts,
                        text: Word.Paywall.SavingsAccount.desc,
                        color: .blue,
                        isDetailed: false
                    )
                    
                    NavigationLink(destination: {
                        PaywallFeatureDetail(
                            title: "word_budgets".localized,
                            imageWithout: [],
                            imageWith: ["budgetPaywallDetailled"],
                            desc: "paywall_detailled_budgets".localized
                        )
                        .onAppear { EventService.sendEvent(key: .paywallDetailBudgets) }
                    }, label: {
                        PaywallRow(
                            systemName: "chart.pie.fill",
                            title: "word_budgets".localized,
                            text: "paywall_budgets_desc".localized,
                            color: .purple,
                            isDetailed: true
                        )
                    })
                    
                    NavigationLink(destination: {
                        PaywallFeatureDetail(
                            title: "word_statistics".localized,
                            imageWithout: ["stat1WithoutPaywallDetailled", "stat2WithoutPaywallDetailled"],
                            imageWith: ["stat1WithPaywallDetailled", "stat2WithPaywallDetailled"],
                            desc: "paywall_detailled_statistics".localized
                        )
                    }, label: {
                        PaywallRow(
                            systemName: "chart.xyaxis.line",
                            title: "word_statistics".localized,
                            text: "paywall_statistics_desc".localized,
                            color: .yellow,
                            isDetailed: true
                        )
                    })

                    PaywallRow(
                        systemName: "person.fill",
                        title: "paywall_support_dev".localized,
                        text: "paywall_support_dev_desc".localized,
                        color: .blue,
                        isDetailed: false
                    )
                }
                .padding(.horizontal, 24)
            }
            .scrollIndicators(.hidden)
            
            Spacer()
            
            VStack(spacing: 8) {
                if let lifetime = store.lifetime, !store.isCashFlowPro {
                    VStack(spacing: 16) {
//                        Text(timeString(from: timeRemaining))
//                            .font(.Title.semibold)
//                            .foregroundColor(Color.white)
//                            .onReceive(timer) { _ in
//                                if timeRemaining > 0 {
//                                    timeRemaining -= 1
//                                }
//                            }
//                        
//                        Text("Il ne reste plus que 3 produits à acheter avant la fin de la promo !")
//                            .multilineTextAlignment(.center)
//                            .foregroundStyle(Color.red)
//                            .font(.Body.semibold)
                        
                        AsyncButton {
                            if let product = store.products.first {
                                await store.buyProduct(product)
                            }
                        } label: {
                            let fakePrice = lifetime.price * 2
                            PaywallPayementRow(
                                price: lifetime.price.toCurrency(),
                                promoText: fakePrice.toCurrency()
                            )
                        }
                    }
                } else {
                    Text("paywall_thanks".localized)
                        .font(.semiBoldCustom(size: 20))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary500)
                        .cornerRadius(15)
                }
                
                AsyncButton { await store.restorePurchases() } label: {
                    Text("paywall_restore".localized)
                        .font(Font.mediumSmall())
                        .foregroundStyle(Color.primary500)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 8)
            }
            .padding(.horizontal)
            .padding(.top)
            .background(Color.background200)
        } // NavigationStack
        .onAppear {
            EventService.sendEvent(key: .appPaywall)
        }
    } // body
    
    private func timeString(from timeInterval: TimeInterval) -> String {
            let hours = Int(timeInterval) / 3600
            let minutes = Int(timeInterval) / 60 % 60
            let seconds = Int(timeInterval) % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    
} // struct

// MARK: - Preview
#Preview {
    PaywallView()
        .environmentObject(PurchasesManager())
}
