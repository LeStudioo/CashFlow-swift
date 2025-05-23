//
//  EventService+Extensions.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/05/2025.
//

import Foundation
import StatsKit
import UIKit

extension EventService {
    
    static func sendEvent(key: EventKeys) {
        EventService.createEvent(
            events: [
                .init(
                    event: key.rawValue,
                    userId: UIDevice.current.identifierForVendor?.uuidString,
                    properties: .init(
                        projectName: "CashFlow",
                        platform: "iOS"
                    )
                )
            ]
        )
    }
}

extension EventService {
    
    private static func sendTransactionTypeEvent(type: TransactionType) {
        if type == .expense {
            EventService.sendEvent(key: .transactionExpenseCreated)
        } else if type == .income {
            EventService.sendEvent(key: .transactionIncomeCreated)
        }
    }
    
    private static func sendApplePayEvent(isFromApplePay: Bool) {
        if isFromApplePay {
            EventService.sendEvent(key: .transactionCreatedApplePay)
        }
    }
    
    static func sendEventForTransactionCreated(transaction: TransactionModel) {
        EventService.sendEvent(key: .transactionCreated)
        EventService.sendTransactionTypeEvent(type: transaction.type)
        EventService.sendApplePayEvent(isFromApplePay: transaction.isFromApplePay)
    }
    
}
