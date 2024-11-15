//
//  SavingAccountRepo.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/08/2024.
//

import Foundation

final class SavingsAccountRepositoryOld: ObservableObject {
    static let shared = SavingsAccountRepositoryOld()
    
    @Published var savingsAccounts: [SavingsAccount] = []
}

extension SavingsAccountRepositoryOld {
    
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
