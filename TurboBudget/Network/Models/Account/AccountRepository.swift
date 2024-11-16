//
//  AccountRepository.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation

final class AccountRepository: ObservableObject {
    static let shared = AccountRepository()
    
    @Published var accounts: [AccountModel] = []
    @Published var selectedAccount: AccountModel? = nil
    
    var mainAccount: AccountModel? {
        return accounts.first
    }
}

extension AccountRepository {
    
    @MainActor
    func fetchAccounts() async {
        do {
            let accounts = try await NetworkService.shared.sendRequest(
                apiBuilder: AccountAPIRequester.fetch,
                responseModel: [AccountModel].self
            )
            self.accounts = accounts
            print("🔥 ACCOUNTS : \(accounts)")
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func createAccount(body: AccountModel) async {
        do {
            let account = try await NetworkService.shared.sendRequest(
                apiBuilder: AccountAPIRequester.create(body: body),
                responseModel: AccountModel.self
            )
            self.accounts.append(account)
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func updateAccount(accountID: Int, body: AccountModel) async {
        do {
            let account = try await NetworkService.shared.sendRequest(
                apiBuilder: AccountAPIRequester.update(accountID: accountID, body: body),
                responseModel: AccountModel.self
            )
            if let index = self.accounts.map(\.id).firstIndex(of: account.id) {
                self.accounts[index] = account
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteAccount(accountID: Int) async {
        do {
            try await NetworkService.shared.sendRequest(
                apiBuilder: AccountAPIRequester.delete(accountID: accountID)
            )
            self.accounts.removeAll { $0.id == accountID }
        } catch { NetworkService.handleError(error: error) }
    }
}

extension AccountRepository {
    
    func setNewBalance(accountID: Int, newBalance: Double) {
        if let account = accounts.first(where: { $0.id == accountID }) {
            account.balance = newBalance
        }
    }
    
}
