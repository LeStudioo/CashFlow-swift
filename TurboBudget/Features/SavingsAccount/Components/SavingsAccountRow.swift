//
//  SavingsAccountRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI
import TheoKit

struct SavingsAccountRow: View {
    
    // Builder
    var savingsAccount: AccountModel
    
    let width = UIDevice.isIpad ? UIScreen.main.bounds.width / 4 - 16 : UIScreen.main.bounds.width / 2 - 16
    
    // MARK: -
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg200)
                    .cornerRadius(TKDesignSystem.Radius.small)
                    .overlay {
                        Image(.iconLandmark)
                            .renderingMode(.template)
                            .foregroundStyle(Color.label)
                    }
                
                Spacer()
                
                Image(.iconArrowRight)
                    .renderingMode(.template)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
            }
            
            Text(savingsAccount.balance.toCurrency())
                .fontWithLineHeight(DesignSystem.Fonts.Title.large)
                .lineLimit(1)
                .frame(maxHeight: .infinity)
                .foregroundStyle(Color.label)
            
            Text(savingsAccount.name)
                .fontWithLineHeight(DesignSystem.Fonts.Body.medium)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .foregroundStyle(Color.label)
        }
        .padding(TKDesignSystem.Padding.standard)
        .aspectRatio(1, contentMode: .fit)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: TKDesignSystem.Radius.standard,
            lineWidth: 1,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsAccountRow(savingsAccount: .mockSavingsAccount)
}
