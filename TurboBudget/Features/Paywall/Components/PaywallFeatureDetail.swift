//
//  PaywallFeatureDetail.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI

struct PaywallFeatureDetail: View {
    
    var title: String
    var imageWithout: [String]
    var imageWith: [String]
    var desc: String
    
    // MARK: -
    var body: some View {
        ScrollView {
            Text(title)
                .font(DesignSystem.FontDS.Title.semibold)
            
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
                                    .padding(.horizontal, UIDevice.isIpad ? 64 : 48)
                            }
                    }
                }
            }
            Spacer()
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 8)
    } // body
} // struct

// MARK: - Preview
#Preview {
    PaywallFeatureDetail(
        title: "word_budgets".localized,
        imageWithout: [],
        imageWith: ["budgetPaywallDetailled"],
        desc: "paywall_detailled_budgets".localized
    )
    .background(Color.background)
}
