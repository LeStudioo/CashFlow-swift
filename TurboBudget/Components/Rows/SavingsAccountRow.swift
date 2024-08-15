//
//  SavingsAccountRow.swift
//  CashFlow
//
//  Created by KaayZenn on 20/02/2024.
//

import SwiftUI

struct SavingsAccountRow: View {
    
    // Builder
    @ObservedObject var savingsAccount: SavingsAccount
    
    // Environment
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - body
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.colorCell)
                    .cornerRadius(12)
                    .overlay {
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(uiColor: .label))
                    }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(uiColor: .label))
            }
            .padding(.top)
            
            Text(savingsAccount.balance.formatted() + " \(Locale.current.currencySymbol ?? "")")
                .font(.boldH3())
                .foregroundStyle(Color(uiColor: .label))
                .lineLimit(1)
            
            Text(savingsAccount.name)
                .font(.semiBoldSmall())
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(uiColor: .label))
                .lineLimit(2)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .frame(height: 150)
        .background(Color.colorCell)
        .cornerRadius(15)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SavingsAccountRow(savingsAccount: SavingsAccount.preview)
}
