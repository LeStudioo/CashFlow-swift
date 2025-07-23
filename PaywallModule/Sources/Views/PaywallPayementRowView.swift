//
//  PaywallPayementRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI
import CoreModule

struct PaywallPayementRowView: View {
    
    var price: String
    var promoText: String
    
    // MARK: -
    var body: some View {
        HStack {
            Text(Word.Paywall.lifetime)
                .font(Font.semiBoldText16())
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(promoText)
                .font(.semiBoldText16())
                .foregroundStyle(.black)
                .overlay {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.black)
                }
            
            Text(price)
                .font(.semiBoldText16())
        }
        .foregroundStyle(.white)
        .padding()
        .background(Color.primary500)
        .cornerRadius(12)
        .overlay(alignment: .topTrailing) {
            Text("-50%".localized)
                .font(.semiBoldVerySmall())
                .foregroundStyle(.white)
                .padding(4)
                .background(Color.red)
                .cornerRadius(30)
                .offset(x: 6, y: -10)
            
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    PaywallPayementRowView(
        price: "23.99€",
        promoText: "56.12€"
    )
}
