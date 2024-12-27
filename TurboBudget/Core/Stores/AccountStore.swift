//
//  AccountStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation

final class AccountStore: ObservableObject {
    static let shared = AccountStore()
    
    @Published var accounts: [AccountModel] = []
    @Published var savingsAccounts: [AccountModel] = []
    
    @Published var selectedAccount: AccountModel?
    
    @Published var cashflow: [Double] = []
    @Published var stats: StatisticsModel?
    
    var allAccounts: [AccountModel] {
        return accounts + savingsAccounts
    }
    
    var mainAccount: AccountModel? {
        return accounts.first
    }
}

extension AccountStore {
    
    @MainActor
    func fetchAccounts() async {
        do {
            let accounts = try await NetworkService.shared.sendRequest(
                apiBuilder: AccountAPIRequester.fetch,
                responseModel: [AccountModel].self
            )
            self.accounts = accounts.filter { $0.type == .classic }
            if self.accounts.count == 1 {
                self.selectedAccount = self.accounts.first
            }
            self.savingsAccounts = accounts.filter { $0.type == .savings }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createAccount(body: AccountModel) async -> AccountModel? {
        do {
            let account = try await NetworkService.shared.sendRequest(
                apiBuilder: AccountAPIRequester.create(body: body),
                responseModel: AccountModel.self
            )
            if account.type == .classic {
                self.accounts.append(account)
            } else if account.type == .savings {
                self.savingsAccounts.append(account)
            }
            return account
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func updateAccount(accountID: Int, body: AccountModel) async {
        do {
            let account = try await NetworkService.shared.sendRequest(
                apiBuilder: AccountAPIRequester.update(accountID: accountID, body: body),
                responseModel: AccountModel.self
            )
            if account.type == .classic {
                if let index = self.accounts.map(\.id).firstIndex(of: account.id) {
                    self.accounts[index]._name = account.name
                    if selectedAccount?.id == accountID {
                        selectedAccount = nil
                        selectedAccount = self.accounts[index]
                    }
                }
            } else if account.type == .savings {
                if let index = self.savingsAccounts.map(\.id).firstIndex(of: account.id) {
                    self.savingsAccounts[index]._name = account.name
                    self.savingsAccounts[index].maxAmount = account.maxAmount
                }
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
            self.savingsAccounts.removeAll { $0.id == accountID }
            if selectedAccount?.id == accountID {
                TransactionStore.shared.transactions = []
                SubscriptionStore.shared.subscriptions = []
                SavingsPlanStore.shared.savingsPlans = []
                BudgetStore.shared.budgets = []
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func fetchCashFlow(accountID: Int, year: Int) async {
        do {
            let results = try await NetworkService.shared.sendRequest(
                apiBuilder: AccountAPIRequester.cashflow(accountID: accountID, year: year),
                responseModel: [Double].self
            )
            self.cashflow = results
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func fetchStats(accountID: Int, withSavings: Bool) async {
        do {
            let results = try await NetworkService.shared.sendRequest(
                apiBuilder: AccountAPIRequester.stats(accountID: accountID, withSavings: withSavings),
                responseModel: StatisticsModel.self
            )
            self.stats = results
        } catch { NetworkService.handleError(error: error) }
    }
}

extension AccountStore {
    
    func findByID(_ id: Int) -> AccountModel? {
        return self.allAccounts.first(where: { $0.id == id })
    }
    
    func setNewBalance(accountID: Int, newBalance: Double) {
        if let account = accounts.first(where: { $0.id == accountID }) {
            account._balance = newBalance
            if let selectedAccount, selectedAccount.id == accountID {
                selectedAccount._balance = newBalance
            }
        } else if let account = savingsAccounts.first(where: { $0.id == accountID }) {
            account._balance = newBalance
        }
    }
    
}
