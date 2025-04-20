//
//  AccountStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation
import NetworkKit

final class AccountStore: ObservableObject {
    static let shared = AccountStore()
    
    @Published var accounts: [AccountModel] = []
    @Published var savingsAccounts: [AccountModel] = []
    
    @Published private(set) var selectedAccount: AccountModel?
    
    @Published var cashflow: [Double] = []
    @Published var stats: StatisticsModel?
    
    var allAccounts: [AccountModel] {
        return accounts + savingsAccounts
    }
}

extension AccountStore {
    
    @MainActor
    func fetchAccounts() async {
        do {
            let accounts = try await AccountService.fetchAll()
            
            self.accounts = accounts.filter { $0.type == .classic }
            self.savingsAccounts = accounts.filter { $0.type == .savings }

            self.selectedAccount = self.accounts.sorted { $0.createdAt ?? .now < $1.createdAt ?? .now }.first
        } catch { NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createAccount(body: AccountModel) async -> AccountModel? {
        do {
            let account = try await AccountService.create(body: body)
            if account.type == .classic {
                self.accounts.append(account)
                if selectedAccount == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.selectedAccount = account
                    }
                }
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
            let account = try await AccountService.update(id: accountID, body: body)
            
            if account.type == .classic {
                if let index = self.accounts.firstIndex(where: { $0._id == accountID }) {
                    self.accounts[index] = account
                    if selectedAccount?._id == accountID {
                        selectedAccount = nil
                        selectedAccount = self.accounts[index]
                    }
                }
            } else if account.type == .savings {
                if let index = self.savingsAccounts.firstIndex(where: { $0._id == accountID }) {
                    self.savingsAccounts[index] = account
                }
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteAccount(accountID: Int) async {
        do {
            try await AccountService.delete(id: accountID)
            
            self.accounts.removeAll { $0._id == accountID }
            self.savingsAccounts.removeAll { $0._id == accountID }
            
            if selectedAccount?._id == accountID {
                TransactionStore.shared.reset()
                SubscriptionStore.shared.reset()
                SavingsPlanStore.shared.reset()
                BudgetStore.shared.reset()
                selectedAccount = nil
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func fetchCashFlow(accountID: Int, year: Int) async {
        do {
            self.cashflow = try await AccountService.fetchCashFlow(id: accountID, year: year)
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func fetchStats(accountID: Int, withSavings: Bool) async {
        do {
            self.stats = try await AccountService.fetchStats(id: accountID, withSavings: withSavings)
        } catch { NetworkService.handleError(error: error) }
    }
}

extension AccountStore {
    
    func cashFlowAmount(for month: Date) -> Double {
        let monthNum = month.month - 1
        if cashflow.isNotEmpty {
            return cashflow[monthNum]
        } else { return 0 }
    }
    
}

extension AccountStore {
    
    func findByID(_ id: Int) -> AccountModel? {
        return self.allAccounts.first(where: { $0._id == id })
    }
    
    func setNewBalance(accountID: Int, newBalance: Double) {
        if let accountIndex = accounts.firstIndex(where: { $0._id == accountID }) {
            self.accounts[accountIndex]._balance = newBalance
            if let selectedAccount, selectedAccount._id == accountID {
                self.selectedAccount?._balance = newBalance
            }
        } else if let savingsAccountIndex = savingsAccounts.firstIndex(where: { $0._id == accountID }) {
            self.savingsAccounts[savingsAccountIndex]._balance = newBalance
        }
    }
    
    func setNewAccount(account: AccountModel?) {
        guard let account else { return }
        self.selectedAccount = account
    }
    
}
