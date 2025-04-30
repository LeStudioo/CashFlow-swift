//
//  TransactionResponseWithBalance.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/11/2024.
//

import Foundation

struct TransactionResponseWithBalance: Codable {
    var newBalance: Double?
    var transaction: TransactionDTO?
}
