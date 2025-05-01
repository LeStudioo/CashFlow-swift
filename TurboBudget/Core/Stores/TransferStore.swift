//
//  TransferStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import Foundation
import NetworkKit
import StatsKit

final class TransferStore: ObservableObject {
    static let shared = TransferStore()
    
    @Published var transfers: [TransactionModel] = []
    
    var monthsOfTransfers: [Date] {
        let calendar = Calendar.current
        
        let uniqueMonths = Set(transfers.map {
            calendar.dateComponents([.month, .year], from: $0.date)
        })
        
        return uniqueMonths.compactMap { calendar.date(from: $0) }.sorted(by: >)
    }
}

extension TransferStore {
    
    @MainActor
    func fetchTransfersWithPagination(accountID: Int, perPage: Int = 50) async {
        do {
            let transfers = try await NetworkService.sendRequest(
                apiBuilder: TransactionAPIRequester.fetchWithPagination(
                    accountID: accountID,
                    perPage: perPage,
                    skip: self.transfers.count
                ),
                responseModel: [TransactionDTO].self
            ).map { try $0.toModel() }
            self.transfers += transfers
            sortTransfersByDate()
        } catch { NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createTransfer(senderAccountID: Int, receiverAccountID: Int, body: TransferBody) async -> TransactionModel? {
        do {
            let response = try await TransferService.create(from: senderAccountID, to: receiverAccountID, body: body)
            
            guard let transfer = try response.transaction?.toModel() else { return nil }
            guard let senderNewBalance = response.senderNewBalance else { return nil }
            guard let receiverNewBalance = response.receiverNewBalance else { return nil }
            
            AccountStore.shared.setNewBalance(accountID: senderAccountID, newBalance: senderNewBalance)
            AccountStore.shared.setNewBalance(accountID: receiverAccountID, newBalance: receiverNewBalance)
            self.transfers.append(transfer)
            sortTransfersByDate()
            
            if let selectedAccountID = AccountStore.shared.selectedAccount?._id, senderAccountID == selectedAccountID
                || receiverAccountID == selectedAccountID {
                TransactionStore.shared.transactions.append(transfer)
                TransactionStore.shared.sortTransactionsByDate()
            }
            EventService.sendEvent(key: .transferCreated)
            return transfer
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func deleteTransfer(transferID: Int) async {
        do {
            let response = try await TransferService.delete(id: transferID)
            
            guard let transfer = transfers.first(where: { $0.id == transferID }) else { return }
            guard let senderAccountID = transfer.senderAccount?._id, let receiverAccountID = transfer.receiverAccount?._id else { return }
            
            if let senderNewBalance = response.senderNewBalance, let receiverNewBalance = response.receiverNewBalance {
                AccountStore.shared.setNewBalance(accountID: senderAccountID, newBalance: senderNewBalance)
                AccountStore.shared.setNewBalance(accountID: receiverAccountID, newBalance: receiverNewBalance)
            }
            
            if let index = self.transfers.firstIndex(where: { $0.id == transferID }) {
                self.transfers.remove(at: index)
                EventService.sendEvent(key: .transferDeleted)
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
}

extension TransferStore {
    func sortTransfersByDate() {
        self.transfers.sort { $0.date > $1.date }
    }
}
