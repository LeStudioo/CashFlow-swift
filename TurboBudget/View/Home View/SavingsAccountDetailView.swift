//
//  SavingsAccountDetailView.swift
//  CashFlow
//
//  Created by KaayZenn on 20/02/2024.
//

import SwiftUI

struct SavingsAccountDetailView: View {
    
    // Builder
    @ObservedObject var savingsAccount: SavingsAccount
    
    // Computed variables
    var getAllMonthForTransactions: [DateComponents] {
        var array: [DateComponents] = []
        for transfer in savingsAccount.transfers {
            let components = Calendar.current.dateComponents([.month, .year], from: transfer.date)
            if !array.contains(components) { array.append(components) }
        }
        return array
    }
    
    // MARK: - body
    var body: some View {
        List {
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.colorCell)
                        .overlay {
                            Circle()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(HelperManager().getAppTheme().color)
                                .shadow(color:HelperManager().getAppTheme().color, radius: 4, y: 2)
                                .overlay {
                                    VStack {
                                        Image(systemName: "building.columns.fill")
                                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                                            .foregroundStyle(Color(uiColor: .systemBackground))
                                        
                                    }
                                }
                        }
                    Spacer()
                }
                
                Text(savingsAccount.name)
                    .titleAdjustSize()
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
            
            ForEach(getAllMonthForTransactions, id: \.self) { dateComponents in
                if let month = Calendar.current.date(from: dateComponents) {
                    if savingsAccount.transfers.map({ $0.date }).contains(where: { Calendar.current.isDate($0, equalTo: month, toGranularity: .month) }) {
                        Section(content: {
                            ForEach(savingsAccount.transfers) { transfer in
                                if Calendar.current.isDate(transfer.date, equalTo: month, toGranularity: .month) {
                                    CellTransferView(transfer: transfer)
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                            .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
                        }, header: {
                            DetailOfTransferByMonth(
                                month: month,
                                amountOfSavings: savingsAccount.amountOfSavingsByMonth(month: month),
                                amountOfWithdrawal: savingsAccount.amountOfWithdrawalByMonth(month: month)
                            )
                            .listRowInsets(EdgeInsets(top: -12, leading: 0, bottom: 8, trailing: 0))
                        })
                        .foregroundStyle(Color(uiColor: .label))
                    }
                }
            }
        } // End List
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SavingsAccountDetailView(savingsAccount: .preview)
}
