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
    
    // MARK: - body
    var body: some View {
            List {
                VStack {
                    HStack {
                        Spacer()
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.colorCell)
                            .overlay {
                                Circle()
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(HelperManager().getAppTheme().color)
                                    .shadow(color: HelperManager().getAppTheme().color, radius: 4, y: 2)
                                    .overlay {
                                        VStack {
                                            Image(systemName: "building.columns.fill")
                                                .font(.system(size: 32, weight: .semibold, design: .rounded))
                                                .foregroundColor(.colorLabelInverse)
                                            
                                        }
                                    }
                            }
                        Spacer()
                    }
                    
                    Text("word_savings_account".localized)
                        .titleAdjustSize()
                }
            } // End List
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
    } // End body
} // End struct

//MARK: - Preview
//#Preview {
//    SavingsAccountHomeView()
//}
