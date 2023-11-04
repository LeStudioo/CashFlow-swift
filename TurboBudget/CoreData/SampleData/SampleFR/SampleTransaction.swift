//
//  sampleTransaction.swift
//  CashFlow
//
//  Created by KaayZenn on 26/10/2023.
//

import Foundation

//MARK: - One month
func sampleTransaction1() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Figurine"
    transaction.amount = -15
    transaction.date = datesOfOctober2023[2]
    transaction.predefCategoryID = categoryPredefined1.idUnique
    transaction.predefSubcategoryID = subCategory6Category1.idUnique
    
    return transaction
}

func sampleTransaction2() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Lidl"
    transaction.amount = -70
    transaction.date = datesOfOctober2023[3]
    transaction.predefCategoryID = categoryPredefined2.idUnique
    transaction.predefSubcategoryID = subCategory3Category2.idUnique
    
    return transaction
}

func sampleTransaction3() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Docteur"
    transaction.amount = -50
    transaction.date = datesOfOctober2023[5]
    transaction.predefCategoryID = categoryPredefined10.idUnique
    transaction.predefSubcategoryID = subCategory1Category10.idUnique
    
    return transaction
}

func sampleTransaction4() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Disque dur"
    transaction.amount = -60
    transaction.date = datesOfOctober2023[7]
    transaction.predefCategoryID = categoryPredefined1.idUnique
    transaction.predefSubcategoryID = subCategory4Category1.idUnique
    
    return transaction
}

func sampleTransaction5() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Carburant"
    transaction.amount = -80
    transaction.date = datesOfOctober2023[8]
    transaction.predefCategoryID = categoryPredefined11.idUnique
    transaction.predefSubcategoryID = subCategory3Category11.idUnique
    
    return transaction
}

func sampleTransaction6() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Support casque"
    transaction.amount = -20
    transaction.date = datesOfOctober2023[10]
    transaction.predefCategoryID = categoryPredefined1.idUnique
    transaction.predefSubcategoryID = subCategory4Category1.idUnique
    
    return transaction
}

func sampleTransaction7() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Chargeur"
    transaction.amount = -25
    transaction.date = datesOfOctober2023[11]
    transaction.predefCategoryID = categoryPredefined1.idUnique
    transaction.predefSubcategoryID = subCategory4Category1.idUnique
    
    return transaction
}

func sampleTransaction8() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = NSLocalizedString("sample_cadeau", comment: "")
    transaction.amount = -40
    transaction.date = datesOfOctober2023[13]
    transaction.predefCategoryID = categoryPredefined1.idUnique
    transaction.predefSubcategoryID = subCategory2Category1.idUnique
    
    return transaction
}

func sampleTransaction9() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = NSLocalizedString("sample_croquette", comment: "")
    transaction.amount = -50
    transaction.date = datesOfOctober2023[14]
    transaction.predefCategoryID = categoryPredefined3.idUnique
    transaction.predefSubcategoryID = subCategory3Category3.idUnique
    
    return transaction
}

func sampleTransaction10() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = NSLocalizedString("sample_boite", comment: "")
    transaction.amount = -30
    transaction.date = datesOfOctober2023[15]
    transaction.predefCategoryID = categoryPredefined8.idUnique
    transaction.predefSubcategoryID = subCategory2Category8.idUnique
    
    return transaction
}

func sampleTransaction11() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = NSLocalizedString("sample_repas_travail", comment: "")
    transaction.amount = -30
    transaction.date = datesOfOctober2023[17]
    transaction.predefCategoryID = categoryPredefined12.idUnique
    transaction.predefSubcategoryID = subCategory4Category12.idUnique
    
    return transaction
}

func sampleTransaction12() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = NSLocalizedString("sample_retrait", comment: "")
    transaction.amount = -60
    transaction.date = datesOfOctober2023[18]
    transaction.predefCategoryID = categoryPredefined9.idUnique
    
    return transaction
}

func sampleTransaction13() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Netflix"
    transaction.amount = -20
    transaction.date = datesOfOctober2023[20]
    transaction.predefCategoryID = categoryPredefined8.idUnique
    transaction.predefSubcategoryID = subCategory1Category8.idUnique
    
    return transaction
}

func sampleTransaction14() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Taxi"
    transaction.amount = -40
    transaction.date = datesOfOctober2023[22]
    transaction.predefCategoryID = categoryPredefined11.idUnique
    transaction.predefSubcategoryID = subCategory9Category11.idUnique
    
    return transaction
}

func sampleTransaction15() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Parking"
    transaction.amount = -20
    transaction.date = datesOfOctober2023[23]
    transaction.predefCategoryID = categoryPredefined11.idUnique
    transaction.predefSubcategoryID = subCategory8Category11.idUnique
    
    return transaction
}

func sampleTransaction16() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Free"
    transaction.amount = -20
    transaction.date = datesOfOctober2023[25]
    transaction.predefCategoryID = categoryPredefined7.idUnique
    transaction.predefSubcategoryID = subCategory4Category7.idUnique
    
    return transaction
}

func sampleTransaction17() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Fast & Furious"
    transaction.amount = -30
    transaction.date = datesOfOctober2023[28]
    transaction.predefCategoryID = categoryPredefined8.idUnique
    transaction.predefSubcategoryID = subCategory4Category8.idUnique
    
    return transaction
}

func sampleTransaction18() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Burger King"
    transaction.amount = -9.5
    transaction.date = datesOfOctober2023[30]
    transaction.predefCategoryID = categoryPredefined2.idUnique
    transaction.predefSubcategoryID = subCategory2Category2.idUnique
    
    return transaction
}

func sampleTransaction0() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "Salaire"
    transaction.amount = 1750
    transaction.date = datesOfOctober2023[0]
    transaction.predefCategoryID = categoryPredefined0.idUnique
    
    return transaction
}
