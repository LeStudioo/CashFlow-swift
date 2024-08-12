//
//  AccountRepository.swift
//  CashFlow
//
//  Created by KaayZenn on 12/08/2024.
//

import Foundation

final class AccountRepository: ObservableObject {
    static let shared = AccountRepository()
    
    @Published var mainAccount: Account? = nil
}

extension AccountRepository {
    
    func fetchMainAccount() {
        let request = Account.fetchRequest()
        
        do {
            let accounts = try persistenceController.container.viewContext.fetch(request)
            self.mainAccount = accounts.first
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
}
