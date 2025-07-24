//
//  EventService+Extensions.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/05/2025.
//

import Foundation
import StatsKit
import UIKit
import CoreModule

//extension EventService {
//    
//    static func sendEvent(key: EventKeys) {
//        EventService.createEvent(
//            events: [
//                .init(
//                    event: key.rawValue,
//                    userId: UIDevice.current.identifierForVendor?.uuidString,
//                    properties: .init(
//                        projectName: "CashFlow",
//                        platform: "iOS"
//                    )
//                )
//            ]
//        )
//    }
//    
//}

extension EventService {
    
    @MainActor
    private static func sendTransactionTypeEvent(type: TransactionType) {
        if type == .expense {
            EventService.sendEvent(key: EventKeys.transactionExpenseCreated)
        } else if type == .income {
            EventService.sendEvent(key: EventKeys.transactionIncomeCreated)
        }
    }
    
    @MainActor
    private static func sendApplePayEvent(isFromApplePay: Bool) {
        if isFromApplePay {
            EventService.sendEvent(key: EventKeys.transactionCreatedApplePay)
        }
    }
    
    @MainActor
    static func sendEventForTransactionCreated(transaction: TransactionModel) {
        EventService.sendEvent(key: EventKeys.transactionCreated)
        EventService.sendTransactionTypeEvent(type: transaction.type)
        EventService.sendApplePayEvent(isFromApplePay: transaction.isFromApplePay)
    }
    
}
