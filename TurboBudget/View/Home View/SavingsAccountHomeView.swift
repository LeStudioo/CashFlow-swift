//
//  SavingsAccountHomeView.swift
//  CashFlow
//
//  Created by KaayZenn on 23/11/2023.
//

import SwiftUI

struct SavingsAccountHomeView: View {
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountRepository
    @Environment(\.dismiss) private var dismiss
    
    // String variables
    @State private var searchText: String = ""
    
    // Computed variables
    var totalSavings: Double {
        return accountRepository.savingsAccounts
            .map { $0.balance }
            .reduce(0, +)
    }
    
    var columns: [GridItem] {
        if isIPad {
            return [GridItem(), GridItem(), GridItem(), GridItem()]
        } else {
            return [GridItem(), GridItem()]
        }
    }
    
    // MARK: - body
    var body: some View {
        ScrollView {
            VStack(spacing: -2) {
                Text("savingsAccount_total_savings".localized)
                    .font(Font.mediumText16())
                    .foregroundStyle(Color.customGray)
                HStack {
                    Text(currencySymbol)
                    Text(totalSavings.formatted(style: .decimal))
                }
                .font(.boldH1())
            }
            .padding(.vertical, 12)
            
            LazyVGrid(columns: columns, spacing: 12, content: {
                ForEach(accountRepository.savingsAccounts) { account in
                    NavigationButton(push: router.pushSavingsAccountDetail(savingsAccount: account)) {
                        cellForOnglet(savingsAccount: account)
                    }
                }
            })
            .padding(.horizontal, 8)
        }
        .navigationTitle("word_savings_account".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
        .toolbar {
            ToolbarDismissPushButton()
                        
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationButton(present: router.presentCreateAccount(type: .savings)) {
                    Image(systemName: "plus")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // End body
    
    // MARK: - ViewBuilder
    @ViewBuilder
    func cellForOnglet(savingsAccount: AccountModel) -> some View {
        let width = isIPad ? UIScreen.main.bounds.width / 4 - 16 : UIScreen.main.bounds.width / 2 - 16
        
        VStack(alignment: .center) {
            HStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.componentInComponent)
                    .cornerRadius(12)
                    .overlay {
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(uiColor: .label))
                            .shadow(radius: 2, y: 2)
                    }
                Spacer()
                
//                if savingsAccount.transfers.count != 0 {
//                    Text(String(savingsAccount.transfers.count))
//                        .font(.semiBoldText16())
//                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
            }
            
            Spacer(minLength: 0)
            
            Text(savingsAccount.balance.formatted(style: .currency))
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
        .foregroundStyle(Color.label)
        .frame(width: width, height: width)
        .background(Color.colorCell)
        .cornerRadius(15)
    }
} // End struct

//MARK: - Preview
#Preview {
    SavingsAccountHomeView()
}
