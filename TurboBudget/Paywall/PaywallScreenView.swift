//
//  PaywallScreenView.swift
//  CashFlow
//
//  Created by KaayZenn on 20/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct PaywallScreenView: View {
    
    // EnvironmentObject
    @EnvironmentObject private var store: PurchasesManager
    var isXmarkPresented: Bool = true

    // MARK: -
    var body: some View {
        NavigationStack {
            VStack {
                PaywallHeader(isXmarkPresented: isXmarkPresented)
                    .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        NavigationLink(destination: {
                            PaywallFeatureDetail(
                                title: "word_budgets".localized,
                                imageWithout: [],
                                imageWith: ["budgetPaywallDetailled"],
                                desc: "paywall_detailled_budgets".localized
                            )
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
                        NavigationLink(destination: {
                            PaywallFeatureDetail(
                                title: "paywall_prediction_title".localized,
                                imageWithout: [],
                                imageWith: ["predictionPaywallDetailled"],
                                desc: "paywall_detailled_prediction".localized
                            )
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
                            systemName: "building.columns.fill",
                            title: Word.Main.savingsAccounts,
                            text: Word.Paywall.SavingsAccount.desc,
                            color: .green,
                            isDetailed: false
                        )
                        
                        //                    cellForFeature(systemName: "text.book.closed.fill", title: "word_financial_advice".localized, text: "paywall_financial_advice_desc".localized, color: .green, isDetailed: false)
                        PaywallRow(
                            systemName: "person.fill",
                            title: "paywall_support_dev".localized,
                            text: "paywall_support_dev_desc".localized,
                            color: .blue,
                            isDetailed: false
                        )
                    }
                    .padding(.horizontal, 24)
                    //                    cellForFeature(systemName: "gearshape.2.fill", title: Word.Main.subscriptions, text: "paywall_automations_desc".localized, color: .indigo)
                }
                .scrollIndicators(.hidden)
                
                Spacer()
                
                VStack(spacing: 8) {
                    if let subscription = store.subscription, !store.isCashFlowPro {
                        AsyncButton {
                            if let product = store.products.first {
                                await store.buyProduct(product)
                            }
                        } label: {
                            let fakePrice = subscription.price * 2
                            PaywallPayementRow(
                                price: subscription.price.toCurrency() + " / " + "word_month".localized.lowercased(),
                                promoText: fakePrice.toCurrency()
                            )
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
            }
        } // NavigationStack
    } // body    
} // struct

// MARK: - Preview
#Preview {
    PaywallScreenView()
}


