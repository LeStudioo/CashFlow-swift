//
//  SavingsAccountHomeView.swift
//  CashFlow
//
//  Created by KaayZenn on 23/11/2023.
//

import SwiftUI

struct SavingsAccountHomeView: View {
    
    // CoreData
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SavingsAccount.id, ascending: true)])
    private var savingsAccounts: FetchedResults<SavingsAccount>
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    // String variables
    @State private var searchText: String = ""
    
    // Computed variables
    var totalSavings: Double {
        return savingsAccounts.map { $0.balance }.reduce(0, +)
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
                ForEach(savingsAccounts) { account in
                    Button(action: {
                        router.pushSavingsAccountDetail(savingsAccount: account)
                    }, label: {
                        cellForOnglet(savingsAccount: account)
                    })
                }
            })
            .padding(.horizontal, 8)
        }
        .navigationTitle("word_savings_account".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(uiColor: .label))
                })
            }
                        
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    router.presentCreateSavingsAccount()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // End body
    
    // MARK: - ViewBuilder
    @ViewBuilder
    func cellForOnglet(savingsAccount: SavingsAccount) -> some View {
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
                
                if savingsAccount.transfers.count != 0 {
                    Text(String(savingsAccount.transfers.count))
                        .font(.semiBoldText16())
                }
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
        .foregroundStyle(Color(uiColor: .label))
        .frame(width: width, height: width)
        .background(Color.colorCell)
        .cornerRadius(15)
    }
} // End struct

//MARK: - Preview
#Preview {
    SavingsAccountHomeView()
}
