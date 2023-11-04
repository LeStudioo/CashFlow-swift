//
//  sampleSavingPlan.swift
//  CashFlow
//
//  Created by KaayZenn on 26/10/2023.
//

import Foundation

//MARK: - SavingPlan
func sampleSavingPlan1() -> SavingPlan {
    let savingPlan = SavingPlan(context: previewViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "🚘"
    savingPlan.title = "Voiture"
    savingPlan.amountOfStart = 2000
    savingPlan.actualAmount = 2000
    savingPlan.amountOfEnd = 10000
    
    return savingPlan
}

func sampleSavingPlan2() -> SavingPlan {
    let savingPlan = SavingPlan(context: previewViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "📱"
    savingPlan.title = "iPhone 15"
    savingPlan.amountOfStart = 300
    savingPlan.actualAmount = 300
    savingPlan.amountOfEnd = 969
    
    return savingPlan
}

func sampleSavingPlan3() -> SavingPlan {
    let savingPlan = SavingPlan(context: sampleViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "👕"
    savingPlan.title = "New Clothes"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

func sampleSavingPlan4() -> SavingPlan {
    let savingPlan = SavingPlan(context: sampleViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "✈️"
    savingPlan.title = "Vacation"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

func sampleSavingPlan5() -> SavingPlan {
    let savingPlan = SavingPlan(context: sampleViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "👸"
    savingPlan.title = "New Cosmetic"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

func sampleSavingPlan6() -> SavingPlan {
    let savingPlan = SavingPlan(context: sampleViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "❤️"
    savingPlan.title = "Love"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

//MARK: - Contribution
func sampleContribution1() -> Contribution {
    let contribution = Contribution(context: previewViewContext)
    contribution.id = UUID()
    contribution.amount = 1000
    contribution.date = .now

    return contribution
}

func sampleContribution2() -> Contribution {
    let contribution = Contribution(context: previewViewContext)
    contribution.id = UUID()
    contribution.amount = -500
    contribution.date = .now

    return contribution
}
