//
//  PaywallScreenView.swift
//  CashFlow
//
//  Created by KaayZenn on 20/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct PaywallScreenView: View {

    //Custom type
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared

    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var store: Store

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool

	//Enum
	
	//Computed var

    //MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Text(NSLocalizedString("paywall_title", comment: ""))
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
                            .foregroundColor(.colorMaterial)
                            .overlay {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.colorLabel)
                            }
                    })
                }
                .padding()
                
                ScrollView(showsIndicators: false) {
                    NavigationLink(destination: {
                        pageDetailledFeature(
                            title: NSLocalizedString("word_budgets", comment: ""),
                            imageWithout: [],
                            imageWith: ["budgetPaywallDetailled"],
                            desc: NSLocalizedString("paywall_detailled_budgets", comment: "")
                        )
                    }, label: {
                        cellForFeature(
                            systemName: "chart.pie.fill",
                            title: NSLocalizedString("word_budgets", comment: ""),
                            text: NSLocalizedString("paywall_budgets_desc", comment: ""),
                            color: .purple,
                            isDetailed: true
                        )
                    })
                    NavigationLink(destination: {
                        pageDetailledFeature(
                            title: NSLocalizedString("word_statistics", comment: ""),
                            imageWithout: ["stat1WithoutPaywallDetailled", "stat2WithoutPaywallDetailled"],
                            imageWith: ["stat1WithPaywallDetailled", "stat2WithPaywallDetailled"],
                            desc: NSLocalizedString("paywall_detailled_statistics", comment: "")
                        )
                    }, label: {
                        cellForFeature(
                            systemName: "chart.xyaxis.line",
                            title: NSLocalizedString("word_statistics",comment: ""),
                            text: NSLocalizedString("paywall_statistics_desc",comment: ""),
                            color: .yellow,
                            isDetailed: true
                        )
                    })
                    NavigationLink(destination: {
                        pageDetailledFeature(
                            title: NSLocalizedString("paywall_prediction_title", comment: ""),
                            imageWithout: [],
                            imageWith: ["predictionPaywallDetailled"],
                            desc: NSLocalizedString("paywall_detailled_prediction", comment: "")
                        )
                    }, label: {
                        cellForFeature(systemName: "sparkles", title: NSLocalizedString("paywall_prediction_title", comment: ""), text: NSLocalizedString("paywall_prediction_desc", comment: ""), color: .red, isDetailed: true)
                    })
                    NavigationLink(destination: {
                        pageDetailledFeature(
                            title: NSLocalizedString("word_category", comment: ""),
                            imageWithout: [],
                            imageWith: ["categoryPaywallDetailled"],
                            desc: NSLocalizedString("paywall_detailled_category", comment: "")
                        )
                    }, label: {
                        cellForFeature(systemName: "rectangle.stack", title: NSLocalizedString("word_category", comment: ""), text: NSLocalizedString("paywall_category_desc", comment: ""), color: .blue, isDetailed: true)
                    })
                    cellForFeature(systemName: "text.book.closed.fill", title: NSLocalizedString("word_financial_advice", comment: ""), text: NSLocalizedString("paywall_financial_advice_desc", comment: ""), color: .green, isDetailed: false)
                    cellForFeature(systemName: "person.fill", title: NSLocalizedString("paywall_support_dev", comment: ""), text: NSLocalizedString("paywall_support_dev_desc", comment: ""), color: .blue, isDetailed: false)
                    //                    cellForFeature(systemName: "gearshape.2.fill", title: NSLocalizedString("word_automations", comment: ""), text: NSLocalizedString("paywall_automations_desc", comment: ""), color: .indigo)
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
                                text: NSLocalizedString("paywall_lifetime", comment: ""),
                                price: NSLocalizedString("paywall_price_in_promo", comment: ""),
                                promo: true,
                                promoText: NSLocalizedString("paywall_price_without_promo", comment: ""),
                                promoPerc: NSLocalizedString("-70%", comment: "")
                            )
                        })
                    } else {
                        HStack {
                            Spacer()
                            Text(NSLocalizedString("paywall_thanks", comment: ""))
                                .font(.semiBoldCustom(size: 20))
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.primary500)
                        .cornerRadius(15)
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: { store.restorePurchases() }, label: {
                            Text(NSLocalizedString("paywall_restore", comment: ""))
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
                .foregroundColor(color.opacity(0.3))
                .overlay {
                    Image(systemName: systemName)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(color)
                }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.semiBoldText16())
                    .lineLimit(1)
                    .foregroundStyle(Color.colorLabel)
                Text(text)
                    .font(Font.mediumSmall())
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
            }
            .padding(.leading, 8)
            Spacer(minLength: 0)
            
            if isDetailed {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.colorLabel)
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
                .foregroundColor(.secondary400)
                .if(promo) { view in
                    view
                        .overlay {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.secondary400)
                        }
                }
            Text(price)
                .font(.semiBoldText16())
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.primary500)
        .cornerRadius(12)
        .if(promo) { view in
            view
                .overlay(alignment: .topTrailing) {
                    Text(promoPerc)
                        .font(.semiBoldVerySmall())
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.red)
                        .cornerRadius(30)
                        .offset(x: 6, y: -10)
                }
        }
    }

}//END struct

//MARK: - Preview
#Preview {
    PaywallScreenView()
}
