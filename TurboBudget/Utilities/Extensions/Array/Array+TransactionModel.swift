//
//  Array+TransactionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/12/2024.
//

import Foundation

extension Array where Element == TransactionModel {
    
    func search(for searchText: String) -> [TransactionModel] {
        if searchText.isEmpty { return self }
        
        return self.filter { $0.name.localizedStandardContains(searchText) }
    }
    
}
