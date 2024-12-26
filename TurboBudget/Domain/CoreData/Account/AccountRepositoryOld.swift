//
//  AccountRepositoryOld.swift
//  CashFlow
//
//  Created by KaayZenn on 12/08/2024.
//

import Foundation

final class AccountRepositoryOld: ObservableObject {
    static let shared = AccountRepositoryOld()
    
    @Published var mainAccount: Account?
}

extension AccountRepositoryOld {
    
    func fetchMainAccount() {
        let request = Account.fetchRequest()
        
        do {
            let accounts = try persistenceController.container.viewContext.fetch(request)
            self.mainAccount = accounts.first
            if let mainAccount {
                let accountData = try JSONEncoder().encode(mainAccount)
                let json = "\"account\":" + (String(data: accountData, encoding: .utf8) ?? "")
                DataForServer.shared.accountJSON = json
                print(json)
            }
            
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        if let mainAccount {
            viewContext.delete(mainAccount)
            self.mainAccount = nil
        }
    }
    
}
