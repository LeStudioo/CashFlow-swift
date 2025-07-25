//
//  PaywallScreen.swift
//  CashFlow
//
//  Created by KaayZenn on 20/08/2023.
//
// Localizations 01/10/2023

import SwiftUI
import StatsKit
import CoreModule
import DesignSystemModule

public struct PaywallScreen: View {
    
    // MARK: Environment
    @EnvironmentObject private var store: PurchasesManager
    
    // MARK: Init
    public init() { }
    
    // MARK: - View
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                PaywallHeaderView()
                    .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        NavigationLink(destination: {
                            PaywallFeatureDetailScreen(
                                title: "paywall_prediction_title".localized,
                                imageWithout: [],
                                imageWith: ["predictionPaywallDetailled"],
                                desc: "paywall_detailled_prediction".localized
                            )
                            .onAppear { EventService.sendEvent(key: EventKeys.paywallDetailPrediction) }
                        }, label: {
                            PaywallRowView(
                                systemName: "sparkles",
                                title: "paywall_prediction_title".localized,
                                text: "paywall_prediction_desc".localized,
                                color: .red,
                                isDetailed: true
                            )
                        })
                        
                        PaywallRowView(
                            systemName: "apple.logo",
                            title: "paywall_item_applepay_title".localized,
                            text: "paywall_item_applepay_description".localized,
                            color: .indigo,
                            isDetailed: false
                        )
                        
                        PaywallRowView(
                            systemName: "creditcard.and.123",
                            title: Word.Main.creditCard,
                            text: Word.Paywall.CreditCard.desc,
                            color: .green,
                            isDetailed: false
                        )
                        
                        PaywallRowView(
                            systemName: "creditcard.fill",
                            title: "paywall_item_account_title".localized,
                            text: "paywall_item_account_description".localized,
                            color: .orange,
                            isDetailed: false
                        )
                        
                        PaywallRowView(
                            systemName: "building.columns.fill",
                            title: Word.Main.savingsAccounts,
                            text: Word.Paywall.SavingsAccount.desc,
                            color: .blue,
                            isDetailed: false
                        )
                        
                        NavigationLink(destination: {
                            PaywallFeatureDetailScreen(
                                title: "word_budgets".localized,
                                imageWithout: [],
                                imageWith: ["budgetPaywallDetailled"],
                                desc: "paywall_detailled_budgets".localized
                            )
                            .onAppear { EventService.sendEvent(key: EventKeys.paywallDetailBudgets) }
                        }, label: {
                            PaywallRowView(
                                systemName: "chart.pie.fill",
                                title: "word_budgets".localized,
                                text: "paywall_budgets_desc".localized,
                                color: .purple,
                                isDetailed: true
                            )
                        })
                        
                        NavigationLink(destination: {
                            PaywallFeatureDetailScreen(
                                title: "word_statistics".localized,
                                imageWithout: ["stat1WithoutPaywallDetailled", "stat2WithoutPaywallDetailled"],
                                imageWith: ["stat1WithPaywallDetailled", "stat2WithPaywallDetailled"],
                                desc: "paywall_detailled_statistics".localized
                            )
                        }, label: {
                            PaywallRowView(
                                systemName: "chart.xyaxis.line",
                                title: "word_statistics".localized,
                                text: "paywall_statistics_desc".localized,
                                color: .yellow,
                                isDetailed: true
                            )
                        })
                        
                        PaywallRowView(
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
                        AsyncButton {
                            if let product = store.products.first {
                                await store.buyProduct(product)
                            }
                        } label: {
                            let fakePrice = lifetime.price * 2
                            PaywallPayementRowView(
                                price: lifetime.price.toCurrency(),
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
                .padding(.top)
                .background(Color.Background.bg200)
            }
            .background(Color.Background.bg50)
        } // NavigationStack
        .onAppear {
            EventService.sendEvent(key: EventKeys.appPaywall)
        }
    }
}

// MARK: - Preview
#Preview {
    PaywallScreen()
        .environmentObject(PurchasesManager())
}
