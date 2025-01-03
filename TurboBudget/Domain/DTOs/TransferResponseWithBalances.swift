//
//  TransferResponseWithBalances.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import Foundation

struct TransferResponseWithBalances: Codable {
    var senderNewBalance: Double?
    var receiverNewBalance: Double?
    var transaction: TransactionModel?
}
