//
//  SavingsAccountRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI

struct SavingsAccountRow: View {
    
    // Builder
    var savingsAccount: AccountModel
    
    let width = isIPad ? UIScreen.main.bounds.width / 4 - 16 : UIScreen.main.bounds.width / 2 - 16
    
    // MARK: -
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.background200)
                    .cornerRadius(12)
                    .overlay {
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(uiColor: .label))
                            .shadow(radius: 2, y: 2)
                    }
                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
            }
            
            Spacer(minLength: 0)
            
            Text(savingsAccount.balance.toCurrency())
                .font(.boldH2())
                .multilineTextAlignment(.center)
                .lineLimit(1)
            
            Spacer(minLength: 0)
            
            Text(savingsAccount.name)
                .font(.semiBoldText16())
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .padding()
        .foregroundStyle(Color.text)
        .frame(width: width, height: width)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.background100)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsAccountRow(savingsAccount: .mockSavingsAccount)
}
