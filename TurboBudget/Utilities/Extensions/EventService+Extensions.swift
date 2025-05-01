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

