//
//  SavingsAccountDetailView.swift
//  CashFlow
//
//  Created by KaayZenn on 20/02/2024.
//

import SwiftUI

struct SavingsAccountDetailView: View {
    
    // Builder
    @ObservedObject var savingsAccount: AccountModel
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var transferRepository: TransferRepository
    
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
                                .foregroundStyle(ThemeManager.theme.color)
                                .shadow(color:ThemeManager.theme.color, radius: 4, y: 2)
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
            
            ForEach(transferRepository.monthsOfTransfers, id: \.self) { month in
                Section(content: {
                    ForEach(transferRepository.transfers) { transfer in
                        if Calendar.current.isDate(transfer.date, equalTo: month, toGranularity: .month) {
                            TransferRow(transfer: transfer)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                    .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
                }, header: {
                    DetailOfTransferByMonth(
                        month: month,
                        amountOfSavings: transferRepository.amountOfSavingsByMonth(month: month),
                        amountOfWithdrawal: transferRepository.amountOfWithdrawalByMonth(month: month)
                    )
                    .listRowInsets(EdgeInsets(top: -12, leading: 0, bottom: 8, trailing: 0))
                })
                .foregroundStyle(Color(uiColor: .label))
            }
        } // End List
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationButton(present: router.presentCreateTransfer(receiverAccount: savingsAccount)) {
                    Image(systemName: "plus")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
            }
        }
        .task {
            if let accountID = savingsAccount.id {
                await transferRepository.fetchTransfersWithPagination(accountID: accountID)
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SavingsAccountDetailView(savingsAccount: .mockSavingsAccount)
}
