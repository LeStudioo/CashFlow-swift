//
//  sampleAutomation.swift
//  CashFlow
//
//  Created by KaayZenn on 26/10/2023.
//

import Foundation

func sampleAutomation1() -> Automation {
    let automation = Automation(context: sampleViewContext)
    automation.id = UUID()
    automation.title = "Netflix"
    automation.date = datesOfOctober2023[20]
    automation.isNotif = false
    automation.automationToTransaction = sampleTransaction13()
    
    return automation
}

func sampleAutomation2() -> Automation {
    let automation = Automation(context: sampleViewContext)
    automation.id = UUID()
    automation.title = "Free"
    automation.date = Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? .now
    automation.isNotif = false
    automation.automationToTransaction = previewTransaction7()
    
    return automation
}
