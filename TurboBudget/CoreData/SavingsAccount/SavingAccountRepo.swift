//
//  SavingAccountRepo.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/08/2024.
//

import Foundation

final class SavingsAccountRepo: ObservableObject {
    static let shared = SavingsAccountRepo()
    
    @Published var savingsAccounts: [SavingsAccount] = []
}

extension SavingsAccountRepo {
    
    func fetchSavingsAccounts() {
        let request = SavingsAccount.fetchRequest()
        do {
            let results = try viewContext.fetch(request)
            self.savingsAccounts = results
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
}
