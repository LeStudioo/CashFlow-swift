//
//  SampleFRBudget.swift
//  CashFlow
//
//  Created by KaayZenn on 26/10/2023.
//

import Foundation

func sampleFRBudget1() -> Budget {
    let budget = Budget(context: sampleViewContext)
    budget.id = UUID()
    budget.title = "Preview Budget 1"
    budget.amount = 500
    budget.predefCategoryID = categoryPredefined1.idUnique
    
    return budget
}

func sampleFRBudget2() -> Budget {
    let budget = Budget(context: sampleViewContext)
    budget.id = UUID()
    budget.title = "Preview Budget 2"
    budget.amount = 800
    budget.predefCategoryID = categoryPredefined2.idUnique
    budget.predefSubcategoryID = subCategory1Category2.idUnique
    
    return budget
}
