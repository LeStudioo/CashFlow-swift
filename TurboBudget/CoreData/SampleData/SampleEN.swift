//
//  sampleEN.swift
//  CashFlow
//
//  Created by KaayZenn on 26/10/2023.
//

import Foundation

let sampleENViewContext = PersistenceController.shared.container.viewContext

//MARK: - ACCOUNT
func sampleENAccount1() -> Account {
    let account = Account(context: previewViewContext)
    account.id = UUID()
    account.title = "Preview Account"
    account.balance = 18_915
    account.cardLimit = 3000
    account.position = 1
    account.accountToSavingPlan?.insert(previewSavingPlan1())
    account.accountToSavingPlan?.insert(previewSavingPlan2())
//    account.accountToTransaction?.insert(previewTransaction1())
//    account.accountToTransaction?.insert(previewTransaction2())
//    account.accountToTransaction?.insert(previewTransaction3())
//    account.accountToTransaction?.insert(previewTransaction4())
//    account.accountToTransaction?.insert(previewTransaction5())
//    account.accountToTransaction?.insert(previewTransaction6())
//    account.accountToTransaction?.insert(previewTransaction7())
//    account.accountToTransaction?.insert(previewTransaction8())
    
//    account.accountToAutomation?.insert(previewAutomation1())
//    account.accountToAutomation?.insert(previewAutomation2())
    
//    account.accountToCard = previewCard1()
    
    return account
}

//MARK: - CARD
func sampleENCard1() -> Card {
    let card = Card(context: sampleENViewContext)
    card.id = UUID()
    card.holder = "Preview Holder"
    card.number = "1234 1234 1234 1234"
    card.date = "01/01"
    card.cvv = "123"
    card.limit = 3000
    
    return card
}

//MARK: - TRANSACTION
func sampleENTransaction1() -> Transaction {
    let previewTransaction1 = Transaction(context: sampleENViewContext)
    previewTransaction1.id = UUID()
    previewTransaction1.title = "Preview Transaction 1"
    previewTransaction1.amount = -800
    previewTransaction1.date = Calendar.current.date(byAdding: .day, value: -12, to: Date()) ?? .now
    
    return previewTransaction1
}

func sampleENTransaction2() -> Transaction {
    let transaction = Transaction(context: sampleENViewContext)
    transaction.id = UUID()
    transaction.title = "Preview Transaction 1"
    transaction.amount = -400
    transaction.date = Calendar.current.date(byAdding: .day, value: -8, to: Date()) ?? .now
    
    return transaction
}

func sampleENTransaction3() -> Transaction {
    let transaction = Transaction(context: sampleENViewContext)
    transaction.id = UUID()
    transaction.title = "Preview Transaction 1"
    transaction.amount = -1000
    transaction.date = Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? .now
    
    return transaction
}

func sampleENTransaction4() -> Transaction {
    let transaction = Transaction(context: sampleENViewContext)
    transaction.id = UUID()
    transaction.title = "Preview Transaction 1"
    transaction.amount = -600
    transaction.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? .now
    
    return transaction
}

func sampleENTransaction5() -> Transaction {
    let transaction = Transaction(context: sampleENViewContext)
    transaction.id = UUID()
    transaction.title = "Preview Transaction 1"
    transaction.amount = 800
    transaction.date = Calendar.current.date(byAdding: .day, value: -12, to: Date()) ?? .now
    
    return transaction
}

func sampleENTransaction6() -> Transaction {
    let transaction = Transaction(context: sampleENViewContext)
    transaction.id = UUID()
    transaction.title = "Preview Transaction 1"
    transaction.amount = 400
    transaction.date = Calendar.current.date(byAdding: .day, value: -8, to: Date()) ?? .now
    
    return transaction
}

func sampleENTransaction7() -> Transaction {
    let transaction = Transaction(context: sampleENViewContext)
    transaction.id = UUID()
    transaction.title = "Preview Free"
    transaction.amount = 100
//    transaction.date = Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? .now
    
    return transaction
}

func sampleENTransaction8() -> Transaction {
    let transaction = Transaction(context: sampleENViewContext)
    transaction.id = UUID()
    transaction.title = "Preview Netflix"
    transaction.amount = 600
//    transaction.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? .now
    
    return transaction
}

var sampleENAllTransactions: [Transaction] = [previewTransaction1(), previewTransaction2(), previewTransaction3(), previewTransaction4(), previewTransaction5(), previewTransaction6(), previewTransaction7(), previewTransaction8()]

//MARK: - AUTOMATIONS
func sampleENAutomation1() -> Automation {
    let automation = Automation(context: sampleENViewContext)
    automation.id = UUID()
    automation.title = "Free"
    automation.date = Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? .now
    automation.isNotif = false
    automation.automationToTransaction = previewTransaction7()
    
    return automation
}

func sampleENAutomation2() -> Automation {
    let automation = Automation(context: sampleENViewContext)
    automation.id = UUID()
    automation.title = "Netflix"
    automation.date = Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? .now
    automation.isNotif = false
    automation.automationToTransaction = previewTransaction8()
    
    return automation
}

//MARK: - BUDGETS
func sampleENBudget1() -> Budget {
    let budget = Budget(context: sampleENViewContext)
    budget.id = UUID()
    budget.title = "Preview Budget 1"
    budget.amount = 500
    budget.predefCategoryID = categoryPredefined1.idUnique
    
    return budget
}

func sampleENBudget2() -> Budget {
    let budget = Budget(context: sampleENViewContext)
    budget.id = UUID()
    budget.title = "Preview Budget 2"
    budget.amount = 800
    budget.predefCategoryID = categoryPredefined2.idUnique
    budget.predefSubcategoryID = subCategory1Category2.idUnique
    
    return budget
}

//MARK: - SAVING PLANS
func sampleENSavingPlan1() -> SavingPlan {
    let savingPlan = SavingPlan(context: previewViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "🚙"
    savingPlan.title = "New Car"
    savingPlan.amountOfStart = 1000
    savingPlan.actualAmount = 3250
    savingPlan.amountOfEnd = 5000
    savingPlan.savingPlansToContribution?.insert(previewContribution1())
    savingPlan.savingPlansToContribution?.insert(previewContribution2())
    
    return savingPlan
}

func sampleENSavingPlan2() -> SavingPlan {
    let savingPlan = SavingPlan(context: previewViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "🏠"
    savingPlan.title = "New Home"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

func sampleENSavingPlan3() -> SavingPlan {
    let savingPlan = SavingPlan(context: sampleENViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "👕"
    savingPlan.title = "New Clothes"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

func sampleENSavingPlan4() -> SavingPlan {
    let savingPlan = SavingPlan(context: sampleENViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "✈️"
    savingPlan.title = "Vacation"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

func sampleENSavingPlan5() -> SavingPlan {
    let savingPlan = SavingPlan(context: sampleENViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "👸"
    savingPlan.title = "New Cosmetic"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

func sampleENSavingPlan6() -> SavingPlan {
    let savingPlan = SavingPlan(context: sampleENViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "❤️"
    savingPlan.title = "Love"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

//MARK: - CONTRIBUTIONS
func sampleENContribution1() -> Contribution {
    let contribution = Contribution(context: previewViewContext)
    contribution.id = UUID()
    contribution.amount = 1000
    contribution.date = .now

    return contribution
}

func sampleENContribution2() -> Contribution {
    let contribution = Contribution(context: previewViewContext)
    contribution.id = UUID()
    contribution.amount = -500
    contribution.date = .now

    return contribution
}
