//
//  PaywallScreenView.swift
//  CashFlow
//
//  Created by KaayZenn on 20/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct PaywallScreenView: View {

    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // EnvironmentObject
    @EnvironmentObject private var store: Store

    // MARK: - body
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Text("paywall_title".localized)
                        .font(.boldH2())
                        .foregroundStyle(
                            LinearGradient(colors: [.primary500, .primary500.darker(by: 30)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    Spacer()
                }
                .overlay(alignment: .trailing) {
                    Button(action: { dismiss() }, label: {
                        Circle()
                            .frame(width: 26, height: 26)
                            .foregroundStyle(.colorMaterial)
                            .overlay {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color(uiColor: .label))
                            }
                    })
                }
                .padding()
                
                ScrollView(showsIndicators: false) {
                    NavigationLink(destination: {
                        pageDetailledFeature(
                            title: "word_budgets".localized,
                            imageWithout: [],
                            imageWith: ["budgetPaywallDetailled"],
                            desc: "paywall_detailled_budgets".localized
                        )
                    }, label: {
                        cellForFeature(
                            systemName: "chart.pie.fill",
                            title: "word_budgets".localized,
                            text: "paywall_budgets_desc".localized,
                            color: .purple,
                            isDetailed: true
                        )
                    })
                    NavigationLink(destination: {
                        pageDetailledFeature(
                            title: "word_statistics".localized,
                            imageWithout: ["stat1WithoutPaywallDetailled", "stat2WithoutPaywallDetailled"],
                            imageWith: ["stat1WithPaywallDetailled", "stat2WithPaywallDetailled"],
                            desc: "paywall_detailled_statistics".localized
                        )
                    }, label: {
                        cellForFeature(
                            systemName: "chart.xyaxis.line",
                            title: "word_statistics".localized,
                            text: "paywall_statistics_desc".localized,
                            color: .yellow,
                            isDetailed: true
                        )
                    })
                    NavigationLink(destination: {
                        pageDetailledFeature(
                            title: "paywall_prediction_title".localized,
                            imageWithout: [],
                            imageWith: ["predictionPaywallDetailled"],
                            desc: "paywall_detailled_prediction".localized
                        )
                    }, label: {
                        cellForFeature(systemName: "sparkles", title: "paywall_prediction_title".localized, text: "paywall_prediction_desc".localized, color: .red, isDetailed: true)
                    })
                    NavigationLink(destination: {
                        pageDetailledFeature(
                            title: "word_category".localized,
                            imageWithout: [],
                            imageWith: ["categoryPaywallDetailled"],
                            desc: "paywall_detailled_category".localized
                        )
                    }, label: {
                        cellForFeature(systemName: "rectangle.stack", title: "word_category".localized, text: "paywall_category_desc".localized, color: .blue, isDetailed: true)
                    })
                    cellForFeature(systemName: "text.book.closed.fill", title: "word_financial_advice".localized, text: "paywall_financial_advice_desc".localized, color: .green, isDetailed: false)
                    cellForFeature(systemName: "person.fill", title: "paywall_support_dev".localized, text: "paywall_support_dev_desc".localized, color: .blue, isDetailed: false)
                    //                    cellForFeature(systemName: "gearshape.2.fill", title: "word_automations".localized, text: "paywall_automations_desc".localized, color: .indigo)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    if !store.isLifetimeActive {
                        Button(action: {
                            if let product = store.product(for: "com.Sementa.CashFlow.lifetime") {
                                store.purchaseProduct(product)
                            }
                        }, label: {
                            cellForPayement(
                                text: "paywall_lifetime".localized,
                                price: "paywall_price_in_promo".localized,
                                promo: true,
                                promoText: "paywall_price_without_promo".localized,
                                promoPerc: "-70%".localized
                            )
                        })
                    } else {
                        HStack {
                            Spacer()
                            Text("paywall_thanks".localized)
                                .font(.semiBoldCustom(size: 20))
                            Spacer()
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.primary500)
                        .cornerRadius(15)
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: { store.restorePurchases() }, label: {
                            Text("paywall_restore".localized)
                                .font(Font.mediumSmall())
                                .foregroundStyle(Color.primary500)
                        })
                    }
                    .padding(.trailing, 8)
                }
                .padding(.horizontal)
            }
        } // End Navigation Stack
    }//END body
    
    //MARK: ViewBuilder
    func cellForFeature(systemName: String, title: String, text: String, color: Color, isDetailed: Bool) -> some View {
        HStack {
            Circle()
                .frame(width: 50)
                .foregroundStyle(color.opacity(0.3))
                .overlay {
                    Image(systemName: systemName)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundStyle(color)
                }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.semiBoldText16())
                    .lineLimit(1)
                    .foregroundStyle(Color(uiColor: .label))
                Text(text)
                    .font(Font.mediumSmall())
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .foregroundStyle(Color.customGray)
            }
            .padding(.leading, 8)
            
            Spacer(minLength: 0)
            
            if isDetailed {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(uiColor: .label))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    func pageDetailledFeature(title: String, imageWithout: [String], imageWith: [String], desc: String) -> some View {
        ScrollView {
            Text(title)
                .font(.semiBoldH3())
            
            Text(desc)
                .font(.mediumText16())
                .multilineTextAlignment(.center)
                .padding(.vertical, 8)
                .padding(.bottom, 8)
                .padding(.horizontal)
            
            HStack(spacing: 8) {
                if !imageWithout.isEmpty {
                    VStack {
                        Text("Without CashFlow Pro")
                            .font(.semiBoldText16())
                            .lineLimit(1)
                        ForEach(imageWithout, id: \.self) { image in
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom)
                        }
                    }
                }
                VStack {
                    Text("With CashFlow Pro")
                        .font(.semiBoldText16())
                        .lineLimit(1)
                    ForEach(imageWith, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom)
                            .if(imageWithout.isEmpty) { view in
                                view
                                    .padding(.horizontal, isIPad ? 64 : 48)
                            }
                    }
                }
            }
            Spacer()
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 8)
    }
    
    func cellForPayement(text: String, price: String, promo: Bool, promoText: String, promoPerc: String) -> some View {
        HStack {
            Text(text)
                .font(Font.mediumText16())
            Spacer()
            Text(promoText)
                .font(.semiBoldText16())
                .foregroundStyle(.secondary400)
                .if(promo) { view in
                    view
                        .overlay {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundStyle(.secondary400)
                        }
                }
            Text(price)
                .font(.semiBoldText16())
        }
        .foregroundStyle(.white)
        .padding()
        .background(Color.primary500)
        .cornerRadius(12)
        .if(promo) { view in
            view
                .overlay(alignment: .topTrailing) {
                    Text(promoPerc)
                        .font(.semiBoldVerySmall())
                        .foregroundStyle(.white)
                        .padding(4)
                        .background(Color.red)
                        .cornerRadius(30)
                        .offset(x: 6, y: -10)
                }
        }
    }
} // END struct

// MARK: - Preview
#Preview {
    PaywallScreenView()
}
