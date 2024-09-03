//
//  AutomationModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/08/2024.
//

import Foundation

struct AutomationModel {
    var title: String
    var date: Date
    var frenquently: Int
    var transaction: TransactionEntity?
    
    init(title: String, date: Date, frenquently: Int, transaction: TransactionEntity? = nil) {
        self.title = title
        self.date = date
        self.frenquently = frenquently
        self.transaction = transaction
    }
}
