//
//  CellSavingsAccountView.swift
//  CashFlow
//
//  Created by KaayZenn on 20/02/2024.
//

import SwiftUI

struct CellSavingsAccountView: View {
    
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
                    .foregroundColor(.color3Apple)
                    .cornerRadius(12)
                    .overlay {
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                    }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.colorLabel)
            }
            .padding(.top)
            
            Text(savingsAccount.balance.formatted() + " \(Locale.current.currencySymbol ?? "")")
                .font(.boldH3())
                .foregroundColor(Color(uiColor: .label))
                .lineLimit(1)
            
            Text(savingsAccount.name)
                .font(.semiBoldSmall())
                .multilineTextAlignment(.center)
                .foregroundColor(Color(uiColor: .label))
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
    CellSavingsAccountView(savingsAccount: SavingsAccount.preview)
}
