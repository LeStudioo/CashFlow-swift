//
//  TransactionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/08/2024.
//

import Foundation

struct TransactionModel {    
    var predefCategoryID: String
    var predefSubcategoryID: String
    
    var title: String
    var amount: Double
    var date: Date
    var note: String
    var isAuto: Bool
    var isArchived: Bool
    var comeFromAuto: Bool
    
    var comeFromApplePay: Bool
    var nameFromApplePay: String
    
    var transactionToAccount: Account?
    var transactionToAutomation: Automation?
}
