//
//  AccountManager.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import Foundation
import SwiftUI

class AccountManager {
    
    //MARK: - Helper
    //-------------------- findAccountByItsID ----------------------
    // Description : Trouve un compte en fonction de son ID
    // Parameter : accounts: [Account], id: String
    // Output : return Account?
    // Extra : Cette fonction parcourt la liste des comptes et renvoie le compte correspondant à l'ID fourni. Si aucun compte ne correspond à l'ID, elle renvoie nil.
    //-----------------------------------------------------------
    func findAccountByItsID(accounts: [Account], id: String) -> Account? {
        for account in accounts {
            if account.id.uuidString == id {
                return account
            }
        }
        return nil
    }
    
    //-------------------- groupAndSortTransactionsByMonth ----------------------
    // Description : Toutes les transactions trier par mois
    // Parameter : allTransactions: [Transaction]
    // Output : return [Int: [Transaction]]
    // Extra : allTransactions = TransactionManager().getAllTransactions()
    //-----------------------------------------------------------
    func groupAndSortTransactionsByMonth(allTransactions: [Transaction]) -> [Int: [Transaction]] {
        var groupedTransactions: [Int: [Transaction]] = [1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: [], 10: [], 11: [], 12: []]
        
        let calendar = Calendar.current
        
        for transaction in allTransactions {
            let month = calendar.component(.month, from: transaction.date)
            
            if groupedTransactions[month] == nil {
                groupedTransactions[month] = []
            }
            
            groupedTransactions[month]?.append(transaction)
        }
        
        for (month, transactions) in groupedTransactions {
            groupedTransactions[month] = transactions.sorted(by: { $0.date < $1.date })
        }
        
        return groupedTransactions
    }
    
} // End Class
