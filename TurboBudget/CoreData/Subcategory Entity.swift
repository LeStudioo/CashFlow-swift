//
//  Subcategory+CoreDataProperties.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Subcategory)
public class Subcategory: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subcategory> {
        return NSFetchRequest<Subcategory>(entityName: "Subcategory")
    }

    @NSManaged public var id: UUID
    @NSManaged public var idUnique: String
    @NSManaged public var isPredefined: Bool
    @NSManaged public var title: String
    @NSManaged public var icon: String
    @NSManaged public var colorString: String
    @NSManaged public var subCategoryToTransactions: Set<Transaction>?
    @NSManaged public var subCategoryToCategory: CategoryEntity?
    @NSManaged public var subCategoryToBudget: Budget?

    public var transactions: [Transaction] {
        if let transactions = subCategoryToTransactions {
            return transactions.sorted { $0.date > $1.date }.filter { !$0.isAuto && $0.transactionToCategory != nil && !$0.isArchived }
        } else { return [] }
    }
    
    public func transactionsWithOnlyAutomations() -> [Transaction] {
        return transactions.filter({ $0.comeFromAuto })
    }

    //Return TOTAL expense (return positif number)
    public var amountTotalOfExpenses: Double {
        let array = transactions.map { $0.amount }.filter { $0 < 0 }
        return array.reduce(0, -)
    }
    
    //Return the amount of TOTAL Expenses from Automation (return positif number)
    public var amountTotalOfExpensesAutomations: Double {
        let array = transactions.filter { $0.comeFromAuto && $0.amount < 0 }.map { $0.amount }
        return array.reduce(0, -)
    }
    
    public func transactionsInSelectedMonthAndYear(month: Int, year: Int) -> Double {
        var array: [Transaction] = []
        
        var components = DateComponents()
        components.day = 01
        components.month = month + 1
        components.year = year
        
        let dateOfMonthSelected = Calendar.current.date(from: components)
        
        if let dateOfMonthSelected {
            for transaction in transactions {
                if Calendar.current.isDate(transaction.date, equalTo: dateOfMonthSelected, toGranularity: .month) && Calendar.current.isDate(transaction.date, equalTo: dateOfMonthSelected, toGranularity: .year) {
                    array.append(transaction)
                }
            }
        }
        
        let arrayDouble = array.map { $0.amount }.filter { $0 < 0 }
        return arrayDouble.reduce(0, -)
    }
    
    func expensesTransactionsAmountForSelectedDate(filter: Filter) -> Double {
        var array: [Transaction] = []
        
        for transaction in transactions {
            if filter.byDay {
                if Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .day) &&
                       Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .month) &&
                       Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .year) &&
                       transaction.amount < 0 { array.append(transaction) }
            } else {
                if Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .month) && Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .year) {
                    array.append(transaction)
                }
            }
        }
        
        return array.map { $0.amount }.reduce(0, -)
    }
}

//MARK: - Expenses from automations
extension Subcategory {
    public func expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: Date) -> Double {
        var array: [Transaction] = []
        
        for transaction in transactionsWithOnlyAutomations() {
            if Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) && Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .year) && transaction.amount < 0 {
                array.append(transaction)
            }
        }
        
        return array.filter { !$0.isAuto }.map { $0.amount }.reduce(0, -)
    }
}

//MARK: - Color
extension Subcategory {
    public var color: Color {
        switch colorString {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "mint": return .mint
        case "teal": return .teal
        case "cyan": return .cyan
        case "blue": return .blue
        case "indigo": return .indigo
        case "purple": return .purple
        case "pink": return .pink
        case "brown": return .brown
            
        default:
            return .blue
        }
    }
}

// MARK: Generated accessors for subCategoryToTransactions
extension Subcategory {

    @objc(addSubCategoryToTransactionsObject:)
    @NSManaged public func addToSubCategoryToTransactions(_ value: Transaction)

    @objc(removeSubCategoryToTransactionsObject:)
    @NSManaged public func removeFromSubCategoryToTransactions(_ value: Transaction)

    @objc(addSubCategoryToTransactions:)
    @NSManaged public func addToSubCategoryToTransactions(_ values: NSSet)

    @objc(removeSubCategoryToTransactions:)
    @NSManaged public func removeFromSubCategoryToTransactions(_ values: NSSet)

}

//MARK: - Extension Expenses
extension Subcategory {
    
    //-------------------- getAllExpensesTransactionsForChosenMonth() ----------------------
    // Description : Récupère toutes les transactions qui sont des dépenses, pour un mois donné
    // Parameter : (selectedDate: Date)
    // Output : return [Transaction]
    // Extra : No
    //-----------------------------------------------------------
    func getAllExpensesTransactionsForChosenMonth(selectedDate: Date) -> [Transaction] {
        var transactionsExpenses: [Transaction] = []
        
        for transaction in transactions {
            if transaction.amount < 0 && Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) {
                transactionsExpenses.append(transaction)
            }
        }
        return transactionsExpenses
    }
    
    //-------------------- amountExpensesByMonth() ----------------------
    // Description : Retourne la somme de toutes les transactions qui sont des dépenses, pour un mois donné
    // Parameter : (month: Date)
    // Output : return [Transaction]
    // Extra : No
    //-----------------------------------------------------------
    func amountExpensesByMonth(month: Date) -> Double {
        return getAllExpensesTransactionsForChosenMonth(selectedDate: month).map({ $0.amount }).reduce(0, -)
    }
}

//MARK: - Extension Incomes
extension Subcategory {
    
    //-------------------- getAllTransactionsIncomeForChosenMonth() ----------------------
    // Description : Récupère tous les transactions qui sont des revenus, pour un mois donné
    // Parameter : (selectedDate: Date)
    // Output : return [Transaction]
    // Extra : No
    //-----------------------------------------------------------
    func getAllTransactionsIncomeForChosenMonth(selectedDate: Date) -> [Transaction] {
        var transactionsIncomes: [Transaction] = []
        
        for transaction in transactions {
            if transaction.amount > 0 && Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) && transaction.transactionToCategory != nil { transactionsIncomes.append(transaction) }
        }
        return transactionsIncomes
    }
    
    //-------------------- amountIncomesByMonth() ----------------------
    // Description : Retourne la somme de toutes les transactions qui sont des revenus, pour un mois donné
    // Parameter : (month: Date)
    // Output : return [Transaction]
    // Extra : No
    //-----------------------------------------------------------
    func amountIncomesByMonth(month: Date) -> Double {
        return getAllTransactionsIncomeForChosenMonth(selectedDate: month).map({ $0.amount }).reduce(0, +)
    }
    
}
