//
//  sampleAccount.swift
//  CashFlow
//
//  Created by KaayZenn on 26/10/2023.
//

import Foundation

//MARK: - Account
func sampleAccount1() -> Account {
    
    let load = UserDefaults.standard.bool(forKey: "hello")
    
    let account = Account(context: previewViewContext)
    account.id = UUID()
    account.title = NSLocalizedString("sample_account_name", comment: "")
    account.balance = 18_915
    account.cardLimit = 3000
    account.position = 1
    
        if !load {
    account.accountToTransaction?.insert(sampleTransaction0())
    account.accountToTransaction?.insert(sampleTransaction1())
    account.accountToTransaction?.insert(sampleTransaction2())
    account.accountToTransaction?.insert(sampleTransaction3())
    account.accountToTransaction?.insert(sampleTransaction4())
    account.accountToTransaction?.insert(sampleTransaction5())
    account.accountToTransaction?.insert(sampleTransaction6())
    account.accountToTransaction?.insert(sampleTransaction7())
    account.accountToTransaction?.insert(sampleTransaction8())
    account.accountToTransaction?.insert(sampleTransaction9())
    account.accountToTransaction?.insert(sampleTransaction10())
    account.accountToTransaction?.insert(sampleTransaction11())
    account.accountToTransaction?.insert(sampleTransaction12())
    account.accountToTransaction?.insert(sampleTransaction13())
    account.accountToTransaction?.insert(sampleTransaction14())
    account.accountToTransaction?.insert(sampleTransaction15())
    account.accountToTransaction?.insert(sampleTransaction16())
    account.accountToTransaction?.insert(sampleTransaction17())
    account.accountToTransaction?.insert(sampleTransaction18())
    
    account.accountToTransaction?.insert(sampleTransaction100())
    account.accountToTransaction?.insert(sampleTransaction200())
    account.accountToTransaction?.insert(sampleTransaction300())
    account.accountToTransaction?.insert(sampleTransaction400())
    account.accountToTransaction?.insert(sampleTransaction500())
    account.accountToTransaction?.insert(sampleTransaction600())
    account.accountToTransaction?.insert(sampleTransaction700())
    account.accountToTransaction?.insert(sampleTransaction800())
    account.accountToTransaction?.insert(sampleTransaction900())
//    
            UserDefaults.standard.set(true, forKey: "hello")
        }
    
    account.accountToSavingPlan?.insert(sampleSavingPlan1())
    account.accountToSavingPlan?.insert(sampleSavingPlan2())
    
    account.accountToAutomation?.insert(sampleAutomation1())
    
    return account
}

//MARK: - CARD
func sampleCard1() -> Card {
    let card = Card(context: sampleViewContext)
    card.id = UUID()
    card.holder = "Preview Holder"
    card.number = "1234 1234 1234 1234"
    card.date = "01/01"
    card.cvv = "123"
    card.limit = 3000
    
    return card
}
