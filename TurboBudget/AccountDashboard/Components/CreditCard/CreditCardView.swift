//
//  CreditCardView.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/12/2024.
//

import SwiftUI

struct CreditCardView: View {
    
    // Builder
    var creditCard: CreditCardModel
    
    @EnvironmentObject private var creditCardStore: CreditCardStore
    
    @State private var isFlipped = false

    var currentCreditCard: CreditCardModel {
        return creditCardStore.creditCards.first { $0.id == creditCard.id } ?? creditCard
    }
    
    // MARK: -
    var body: some View {
        ZStack {
            CreditCardFrontView(creditCard: currentCreditCard)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .opacity(isFlipped ? 0 : 1)

            CreditCardBackView(cvv: currentCreditCard.cvc)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -180),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .opacity(isFlipped ? 1 : 0)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                isFlipped.toggle()
            }
        }
    } // body
} // struct

// MARK: - Front
struct CreditCardFrontView: View {
    var creditCard: CreditCardModel

    var body: some View {
        CreditCardShape()
            .overlay {
                VStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Word.CreditCard.numbers.uppercased())
                            .font(.system(size: 12, weight: .medium))
                        Text(creditCard.number)
                            .font(.system(size: 22, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    if let balanceAvailable = creditCard.balanceAvailable {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("account_detail_avail_balance".localized)
                                .font(.system(size: 12, weight: .medium))
                            Text(balanceAvailable.toCurrency())
                                .font(.system(size: 22, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                    HStack(spacing: 8) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Word.CreditCard.holder.uppercased())
                                .font(.system(size: 12, weight: .medium))
                            Text(creditCard.holder)
                                .font(.system(size: 22, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Word.CreditCard.expire.uppercased())
                                .font(.system(size: 12, weight: .medium))
                            Text(creditCard.expirateDate.toDate()?.formatCardExpiration() ?? "00/00")
                                .font(.system(size: 22, weight: .semibold))
                        }
                    }
                }
                .padding()
            }
            .foregroundStyle(Color.white)
    }
}

// MARK: - Back
struct CreditCardBackView: View {
    let cvv: String

    var body: some View {
        CreditCardShape()
            .overlay(
                VStack(spacing: 16) {
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Word.CreditCard.cvv.uppercased())
                            .font(.system(size: 12, weight: .medium))
                        Text(cvv)
                            .font(.system(size: 22, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom)
                    .padding()
                }
            )
            .foregroundStyle(Color.white)
    }
}

// MARK: - Preview
#Preview {
    CreditCardView(creditCard: .mock)
        .padding()
        .environmentObject(ThemeManager())
}
