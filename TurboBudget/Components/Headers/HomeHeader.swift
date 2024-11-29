//
//  HomeHeader.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import SwiftUI

struct HomeHeader: View {
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountRepository
    @EnvironmentObject private var purchaseManager: PurchasesManager
    
    // MARK: -
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let account = accountRepository.mainAccount {
                    Text(currencySymbol + " " + account.balance.formatWith(2))
                        .titleAdjustSize()
                }
                
                Text("home_screen_available_balance".localized)
                    .foregroundStyle(Color.customGray)
                    .font(Font.mediumText16())
            }
            
            Spacer()
            
            if !purchaseManager.isCashFlowPro {
                NavigationButton(present: router.presentPaywall()) {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.primary500)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
            }
            
            NavigationButton(push: router.pushSettings()) {
                Image(systemName: "gearshape.fill")
                    .foregroundStyle(Color.label)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeHeader()
}
