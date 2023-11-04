//
//  CategoryEntity+CoreDataProperties.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(CategoryEntity)
public class CategoryEntity: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var idUnique: String
    @NSManaged public var isPredefined: Bool
    @NSManaged public var title: String
    @NSManaged public var icon: String
    @NSManaged public var colorString: String
    @NSManaged public var categoryToTransactions: Set<Transaction>?
    @NSManaged public var categoryToSubcategory: Set<Subcategory>?
    @NSManaged public var categoryToBudget: Set<Budget>?

    public var transactions: [Transaction] {
        if let transactions = categoryToTransactions {
            return transactions.sorted { $0.date > $1.date }.filter { !$0.isAuto && $0.transactionToCategory != nil && !$0.isArchived }
        } else { return [] }
    }
    
    public var transactionsArchived: [Transaction] {
        if let transactions = categoryToTransactions {
            return transactions.sorted { $0.date > $1.date }.filter({ !$0.isAuto && $0.transactionToCategory != nil && $0.isArchived })
        } else { return [] }
    }
    
    public var subcategories: [Subcategory] {
        if let subcategories = categoryToSubcategory {
            return subcategories.sorted { $0.title < $1.title }
        } else { return [] }
    }
    
    public var budgets: [Budget] {
        if let budgets = categoryToBudget {
            return budgets.sorted { $0.amount > $1.amount }
        } else { return [] }
    }
    
    public func transactionsWithOnlyAutomations() -> [Transaction] {
        return transactions.filter({ $0.comeFromAuto })
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
                 if Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .month) &&
                        Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .year) &&
                        transaction.amount < 0 { array.append(transaction) }
             }
         }
        return array.map { $0.amount }.reduce(0, -)
    }
}

//MARK: - Incomes
extension CategoryEntity {
    
    public var amountTotalOfIncomes: Double {
        let array = transactions.map { $0.amount }.filter { $0 > 0 }
        return array.reduce(0, +)
    }
    
    public var amountTotalOfArchivedTransactionsIncomes: Double {
        let array = transactionsArchived.map { $0.amount }.filter({ $0 > 0 })
        return array.reduce(0, +)
    }
    
    func incomesTransactionsAmountForSelectedDate(filter: Filter) -> Double {
        var array: [Transaction] = []
        for transaction in transactions {
            if filter.byDay {
                if Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .day) &&
                    Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .month) &&
                    Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .year) &&
                    transaction.amount > 0 { array.append(transaction)
                }
            } else {
                if Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .month) &&
                    Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .year) &&
                    transaction.amount > 0 { array.append(transaction)
                }
            }
        }
        return array.map { $0.amount }.reduce(0, +)
    }
    
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

//MARK: - Expenses
extension CategoryEntity {
    
    //Return TOTAL expense (return positif number)
    public var amountTotalOfExpenses: Double {
        let array = transactions.map { $0.amount }.filter({ $0 < 0 })
        return array.reduce(0, -)
    }
    
    public var amountTotalOfArchivedTransactionsExpenses: Double {
        let array = transactionsArchived.map { $0.amount }.filter({ $0 < 0 })
        return array.reduce(0, -)
    }
    
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

//MARK: - Incomes from automations
extension CategoryEntity {
    
    //Return the amount of TOTAL Incomes from Automation (return positif number)
    public var amountTotalOfIncomesAutomations: Double {
        let array = transactions.filter { $0.comeFromAuto && $0.amount > 0 }.map { $0.amount }
        return array.reduce(0, +)
    }
    
    public func incomesAutomationsTransactionsAmountForSelectedDate(selectedDate: Date) -> Double {
        var array: [Transaction] = []
        
        for transaction in transactionsWithOnlyAutomations() {
            if Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) && Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .year) && transaction.amount > 0 {
                array.append(transaction)
            }
        }
        
        return array.map { $0.amount }.reduce(0, +)
    }
    
}

//MARK: - Expenses from automations
extension CategoryEntity {
    
    //Return the amount of TOTAL Expenses from Automation (return positif number)
    public var amountTotalOfExpensesAutomations: Double {
        let array = transactions.filter { $0.comeFromAuto && $0.amount < 0 }.map { $0.amount }
        return array.reduce(0, -)
    }
    
    public func expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: Date) -> Double {
        var array: [Transaction] = []
        
        for transaction in transactionsWithOnlyAutomations() {
            if Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) && Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .year) && transaction.amount < 0 {
                array.append(transaction)
            }
        }
        
        return array.map { $0.amount }.reduce(0, -)
    }
    
}

//MARK: - Color
extension CategoryEntity {
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

// MARK: Generated accessors for categoryToTransactions
extension CategoryEntity {

    @objc(addCategoryToTransactionsObject:)
    @NSManaged public func addToCategoryToTransactions(_ value: Transaction)

    @objc(removeCategoryToTransactionsObject:)
    @NSManaged public func removeFromCategoryToTransactions(_ value: Transaction)

    @objc(addCategoryToTransactions:)
    @NSManaged public func addToCategoryToTransactions(_ values: NSSet)

    @objc(removeCategoryToTransactions:)
    @NSManaged public func removeFromCategoryToTransactions(_ values: NSSet)

}

// MARK: Generated accessors for categoryToSubcategory
extension CategoryEntity {

    @objc(addCategoryToSubcategoryObject:)
    @NSManaged public func addToCategoryToSubcategory(_ value: Subcategory)

    @objc(removeCategoryToSubcategoryObject:)
    @NSManaged public func removeFromCategoryToSubcategory(_ value: Subcategory)

    @objc(addCategoryToSubcategory:)
    @NSManaged public func addToCategoryToSubcategory(_ values: NSSet)

    @objc(removeCategoryToSubcategory:)
    @NSManaged public func removeFromCategoryToSubcategory(_ values: NSSet)

}
