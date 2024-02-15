//
//  SavingsAccountHomeView.swift
//  CashFlow
//
//  Created by KaayZenn on 23/11/2023.
//

import SwiftUI

struct SavingsAccountHomeView: View {
    
    // Builder
    var savingsAccount: SavingsAccount?
    @Binding var update: Bool
    
    // Custom Type
    
    // Environement
    
    // String Variables
    
    // Number Variables
    
    // Bool Variables
    
    // Computed Variables
    var getAllMonthForTransactions: [DateComponents] {
        var array: [DateComponents] = []
        if let savingsAccount {
            for transfer in savingsAccount.transfers {
                let components = Calendar.current.dateComponents([.month, .year], from: transfer.date)
                if !array.contains(components) { array.append(components) }
            }
        }
        return array
    }
    
    //MARK: - Body
    var body: some View {
        if let savingsAccount {
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
                                    .foregroundColor(HelperManager().getAppTheme().color)
                                    .shadow(color:HelperManager().getAppTheme().color, radius: 4, y: 2)
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
                    
                    Text(NSLocalizedString("word_savings_account", comment: ""))
                        .titleAdjustSize()
                }
                
                ForEach(getAllMonthForTransactions, id: \.self) { dateComponents in
                    if let month = Calendar.current.date(from: dateComponents) {
                        if savingsAccount.transfers.map({ $0.date }).contains(where: { Calendar.current.isDate($0, equalTo: month, toGranularity: .month) }) {
                            Section(content: {
                                ForEach(savingsAccount.transfers) { transfer in
                                    if Calendar.current.isDate(transfer.date, equalTo: month, toGranularity: .month) {
                                        ZStack {
                                            NavigationLink(destination: {
                                                //                                            TransactionDetailView(transaction: transaction, update: $update)
                                            }, label: { EmptyView()} )
                                            .opacity(0)
                                            CellTransferView(transfer: transfer, update: $update)
                                        }
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                                .listRowBackground(Color.colorBackground.edgesIgnoringSafeArea(.all))
                            }, header: {
                                DetailOfTransferByMonth(
                                    month: month,
                                    amountOfSavings: savingsAccount.amountOfSavingsByMonth(month: month),
                                    amountOfWithdrawal: savingsAccount.amountOfWithdrawalByMonth(month: month)
                                )
                                .listRowInsets(EdgeInsets(top: -12, leading: 0, bottom: 8, trailing: 0))
                            })
                            .foregroundStyle(Color.colorLabel)
                        }
                    }
                }
            } // End List
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
        }
    } // End body
} // End struct

//MARK: - Preview
//#Preview {
//    SavingsAccountHomeView()
//}
