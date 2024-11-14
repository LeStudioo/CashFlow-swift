//
//  TransactionModelOld.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/08/2024.
//

import Foundation

struct TransactionModelOld {
    var predefCategoryID: String
    var predefSubcategoryID: String
    
    var title: String
    var amount: Double
    var date: Date
    var note: String = ""
    var isAuto: Bool = false
    var isArchived: Bool = false
    var comeFromAuto: Bool = false
    
    var comeFromApplePay: Bool = false
    var nameFromApplePay: String = ""
    
    /// Classic Transaction
    init(
        predefCategoryID: String,
        predefSubcategoryID: String,
        title: String,
        amount: Double,
        date: Date
    ) {
        self.predefCategoryID = predefCategoryID
        self.predefSubcategoryID = predefSubcategoryID
        self.title = title
        self.amount = amount
        self.date = date
    }
    
    /// Transaction for Automation
    init(
        predefCategoryID: String,
        predefSubcategoryID: String,
        title: String,
        amount: Double,
        date: Date,
        isAuto: Bool = true
    ) {
        self.predefCategoryID = predefCategoryID
        self.predefSubcategoryID = predefSubcategoryID
        self.title = title
        self.amount = amount
        self.date = date
        self.isAuto = isAuto
    }
}


//init(predefCategoryID: String, predefSubcategoryID: String, title: String, amount: Double, date: Date, note: String, isAuto: Bool, isArchived: Bool, comeFromAuto: Bool, comeFromApplePay: Bool, nameFromApplePay: String, transactionToAccount: Account? = nil, transactionToAutomation: Automation? = nil) {
//    self.predefCategoryID = predefCategoryID
//    self.predefSubcategoryID = predefSubcategoryID
//    self.title = title
//    self.amount = amount
//    self.date = date
//    self.note = note
//    self.isAuto = isAuto
//    self.isArchived = isArchived
//    self.comeFromAuto = comeFromAuto
//    self.comeFromApplePay = comeFromApplePay
//    self.nameFromApplePay = nameFromApplePay
//    self.transactionToAccount = transactionToAccount
//    self.transactionToAutomation = transactionToAutomation
//}
