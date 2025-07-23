//
//  File.swift
//  CoreModule
//
//  Created by Theo Sementa on 23/07/2025.
//

import Foundation
import StatsKit
import UIKit

public extension EventService {
    
    static func sendEvent(key: EventKeys) {
        EventService.createEvent(
            events: [
                .init(
                    event: key.rawValue,
                    userId: "", //UIDevice.current.identifierForVendor?.uuidString, TODO: Reactivate
                    properties: .init(
                        projectName: "CashFlow",
                        platform: "iOS"
                    )
                )
            ]
        )
    }
    
}
