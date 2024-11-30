//
//  TransferRepository.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import Foundation

final class TransferRepository: ObservableObject {
    static let shared = TransferRepository()
    
    @Published var transfers: [TransactionModel] = []
    
    var monthsOfTransfers: [Date] {
        let calendar = Calendar.current
        
        let uniqueMonths = Set(transfers.map {
            calendar.dateComponents([.month, .year], from: $0.date)
        })
        
        return uniqueMonths.compactMap { calendar.date(from: $0) }.sorted(by: >)
    }
}

extension TransferRepository {
    
    @MainActor
    func fetchTransfersWithPagination(accountID: Int, perPage: Int = 50) async {
        do {
            let transfers = try await NetworkService.shared.sendRequest(
                apiBuilder: TransactionAPIRequester.fetchWithPagination(
                    accountID: accountID,
                    perPage: perPage,
                    skip: self.transfers.count
                ),
                responseModel: [TransactionModel].self
            )
            self.transfers += transfers
            sortTransfersByDate()
        } catch { NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createTransfer(senderAccountID: Int, receiverAccountID: Int, body: TransferBody) async -> TransactionModel? {
        do {
            let response = try await NetworkService.shared.sendRequest(
                apiBuilder: TransferAPIRequester.transfer(senderAccountID: senderAccountID, receiverAccountID: receiverAccountID, body: body),
                responseModel: TransferResponseWithBalances.self
            )
            if let transfer = response.transaction, let senderNewBalance = response.senderNewBalance, let receiverNewBalance = response.receiverNewBalance {
                AccountRepository.shared.setNewBalance(accountID: senderAccountID, newBalance: senderNewBalance)
                AccountRepository.shared.setNewBalance(accountID: receiverAccountID, newBalance: receiverNewBalance)
                self.transfers.append(transfer)
                sortTransfersByDate()
                if let selectedAccountID = AccountRepository.shared.selectedAccount?.id, senderAccountID == selectedAccountID || receiverAccountID == selectedAccountID {
                    TransactionRepository.shared.transactions.append(transfer)
                    TransactionRepository.shared.sortTransactionsByDate()
                }
                return transfer
            }
            return nil
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
}

extension TransferRepository {
    func sortTransfersByDate() {
        self.transfers.sort { $0.date > $1.date }
    }
}
