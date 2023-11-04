//
//  SampleDataHelper.swift
//  CashFlow
//
//  Created by KaayZenn on 26/10/2023.
//

import Foundation

let datesOfOctober2023: [Date] = {
    var dateComponents = DateComponents()
    dateComponents.year = 2023
    dateComponents.month = 10
    let calendar = Calendar.current

    guard let daysCount = calendar.range(of: .day, in: .month, for: calendar.date(from: dateComponents)!)?.count,
          let startDate = calendar.date(from: dateComponents) else {
        return []
    }

    return (0..<daysCount).compactMap { dayOffset in
        calendar.date(byAdding: .day, value: dayOffset, to: startDate)
    }
}()


let januaryFirst: Date = createDateFor(month: 1, year: 2023)
let februaryFirst: Date = createDateFor(month: 2, year: 2023)
let marchFirst: Date = createDateFor(month: 3, year: 2023)
let aprilFirst: Date = createDateFor(month: 4, year: 2023)
let mayFirst: Date = createDateFor(month: 5, year: 2023)
let juneFirst: Date = createDateFor(month: 6, year: 2023)
let julyFirst: Date = createDateFor(month: 7, year: 2023)
let augustFirst: Date = createDateFor(month: 8, year: 2023)
let septemberFirst: Date = createDateFor(month: 9, year: 2023)
let octoberFirst: Date = createDateFor(month: 10, year: 2023)
let novemberFirst: Date = createDateFor(month: 11, year: 2023)
let decemberFirst: Date = createDateFor(month: 12, year: 2023)

func createDateFor(month: Int, year: Int) -> Date {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = 1
    let calendar = Calendar.current
    return calendar.date(from: dateComponents)!
}

//MARK: - All Months
func sampleTransaction100() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "January"
    transaction.amount = 1800
    transaction.date = januaryFirst
    transaction.predefCategoryID = categoryPredefined0.idUnique
    
    return transaction
}

func sampleTransaction200() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "February"
    transaction.amount = 1500
    transaction.date = februaryFirst
    transaction.predefCategoryID = categoryPredefined0.idUnique
    
    return transaction
}

func sampleTransaction300() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "March"
    transaction.amount = 2100
    transaction.date = marchFirst
    transaction.predefCategoryID = categoryPredefined0.idUnique
    
    return transaction
}

func sampleTransaction400() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "April"
    transaction.amount = 1900
    transaction.date = aprilFirst
    transaction.predefCategoryID = categoryPredefined0.idUnique
    
    return transaction
}

func sampleTransaction500() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "May"
    transaction.amount = 1800
    transaction.date = mayFirst
    transaction.predefCategoryID = categoryPredefined0.idUnique
    
    return transaction
}

func sampleTransaction600() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "June"
    transaction.amount = 2000
    transaction.date = juneFirst
    transaction.predefCategoryID = categoryPredefined0.idUnique
    
    return transaction
}

func sampleTransaction700() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "July"
    transaction.amount = 1900
    transaction.date = julyFirst
    transaction.predefCategoryID = categoryPredefined0.idUnique
    
    return transaction
}

func sampleTransaction800() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "August"
    transaction.amount = 1400
    transaction.date = augustFirst
    transaction.predefCategoryID = categoryPredefined0.idUnique
    
    return transaction
}

func sampleTransaction900() -> Transaction {
    let transaction = Transaction(context: sampleViewContext)
    transaction.id = UUID()
    transaction.title = "September"
    transaction.amount = 2800
    transaction.date = septemberFirst
    transaction.predefCategoryID = categoryPredefined0.idUnique
    
    return transaction
}
