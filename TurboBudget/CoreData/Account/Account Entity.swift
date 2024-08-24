//
//  Account+CoreDataProperties.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
//

import Foundation
import CoreData
import CloudKit

@objc(Account)
public class Account: NSManagedObject, Identifiable {
    private let persistenceController = PersistenceController.shared
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var balance: Double
    @NSManaged public var cardLimit: Double
    @NSManaged public var position: Int64
    @NSManaged public var accountToTransaction: Set<Transaction>?
    @NSManaged public var accountToSavingPlan: Set<SavingPlan>?
    @NSManaged public var accountToAutomation: Set<Automation>?
    
    public var allTransactions: [Transaction] {
        if let transactions = accountToTransaction {
            return transactions
                .sorted { $0.date.withDefault > $1.date.withDefault }
                .filter({ !$0.isAuto && PredefinedCategory.findByID($0.predefCategoryID) != nil })
        } else { return [] }
    }

    public var transactions: [Transaction] {
        if let transactions = accountToTransaction {
            return transactions
                .filter({ !$0.isAuto && PredefinedCategory.findByID($0.predefCategoryID) != nil })
                .sorted {
                    if $0.date == $1.date {
                        return $0.title < $1.title
                    } else {
                        return $0.date.withDefault > $1.date.withDefault
                    }
                }
        } else { return [] }
    }
    
    public var transactionsWithOnlyAutomations: [Transaction] {
        return transactions.filter({ $0.comeFromAuto })
    }
    
    public var transactionsFromApplePay: [Transaction] {
        return transactions.filter({ $0.comeFromApplePay })
    }
    
    public var transactionsArchived: [Transaction] {
        if let transactions = accountToTransaction {
            return transactions
                .sorted { $0.date.withDefault > $1.date.withDefault }
                .filter({ !$0.isAuto && PredefinedCategory.findByID($0.predefCategoryID) != nil && $0.isArchived })
        } else { return [] }
    }
    
    public var automations: [Automation] {
        if let automations = accountToAutomation {
            return automations.sorted { $0.date < $1.date }
        } else { return [] }
    }
    
    public var savingPlans: [SavingPlan] {
        if let savingPlans = accountToSavingPlan {
            return savingPlans.sorted { $0.actualAmount > $1.actualAmount }.filter({ !$0.isArchived })
        } else { return [] }
    }
    
    public var savingPlansArchived: [SavingPlan] {
        if let savingPlans = accountToSavingPlan {
            return savingPlans.filter({ $0.isArchived }).sorted { $0.dateOfEnd! > $1.dateOfEnd! }
        } else { return [] }
    }

} // END Class

// MARK: - Accessors for Transactions
extension Account {
    
    public func addNewTransaction(transaction: Transaction) {
        self.accountToTransaction?.insert(transaction)
        
        self.balance += transaction.amount
        
        self.persistenceController.saveContext()
    }
    
    public func deleteTransaction(transaction: Transaction) {
        let context = persistenceController.container.viewContext
        
        self.balance -= transaction.amount
        context.delete(transaction)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.persistenceController.saveContext()
        }
    }
    
}

// MARK: - Preview
extension Account {
    
    static var preview: Account {
        let account = Account(context: previewViewContext)
        account.id = UUID()
        account.title = "Preview Account"
        account.balance = 18_915
        account.cardLimit = 3000
        account.position = 1
        account.accountToAutomation?.insert(Automation.preview)
        account.accountToSavingPlan?.insert(SavingPlan.preview1)
        return account
    }
    
}

//MARK: - Extension Helper
extension Account {
    
    //-------------------- transactionsActualMonth ----------------------
    // Description : Récupére toutes les transactions du mois en cours
    // Parameter :
    // Output :
    // Extra :
    //-----------------------------------------------------------
    private var transactionsActualMonth: [Transaction] {
        var transactionsActualMonth: [Transaction] = []
        let dateOfStartOfTheMonth = Date().startOfMonth
        let dateOfEndOfTheMonth = Date().endOfMonth
        
        for transaction in transactions {
            if transaction.date.withDefault >= dateOfStartOfTheMonth && transaction.date.withDefault <= dateOfEndOfTheMonth {
                transactionsActualMonth.append(transaction)
            }
        }
        return transactionsActualMonth
    }
    
}

//MARK: - Extension Incomes
extension Account {
    
    //-------------------- amountIncomeInActualMonth() ----------------------
    // Description : Montant des revenus sur le mois actuel
    // Parameter : No
    // Output : return Double
    // Extra : transactionsActualMonth = Account.transactionsActualMonth
    //-----------------------------------------------------------
    public func amountIncomeInActualMonth() -> Double {
        var total: Double = 0
        for transaction in transactionsActualMonth {
            if transaction.amount > 0 && PredefinedCategory.findByID(transaction.predefCategoryID) != nil {
                total += transaction.amount
            }
        }
        return total
    }
    
    //-------------------- amountIncomePerDayInActualMonth() ----------------------
    // Description : Montant des revenus sur le mois actuel par jour
    // Parameter : No
    // Output : return [AmountOfTransactionsByDay]
    // Extra : transactionsActualMonth = Account.transactionsActualMonth
    //-----------------------------------------------------------
    public func amountIncomePerDayInActualMonth() -> [AmountOfTransactionsByDay] {
        var array: [AmountOfTransactionsByDay] = []
        let dates = Date().allDateOfMonth
        
        for date in dates {
            var amountOfDay: Double = 0.0
            
            for transaction in transactionsActualMonth {
                if Calendar.current.isDate(transaction.date.withDefault, inSameDayAs: date)
                    && transaction.amount > 0
                    && PredefinedCategory.findByID(transaction.predefCategoryID) != nil {
                    amountOfDay += transaction.amount
                }
            }
            let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) // Bug date -1
            array.append(AmountOfTransactionsByDay(day: newDate!, amount: amountOfDay))
        }
    
        var sortedArray = array.sorted { $0.day < $1.day }
        sortedArray.removeLast() //One value too many
        
        return sortedArray
    }
    
    //-------------------- getAllTransactionsIncomeForChosenMonth() ----------------------
    // Description : Récupère tous les transactions qui sont des revenus, pour un mois donné
    // Parameter : (account: Account, selectedDate: Date)
    // Output : return [Transaction]
    // Extra : No
    //-----------------------------------------------------------
    public func getAllTransactionsIncomeForChosenMonth(selectedDate: Date) -> [Transaction] {
        var transactionsIncomes: [Transaction] = []
        
        for transaction in transactions {
            if transaction.amount > 0 
                && Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month)
                && PredefinedCategory.findByID(transaction.predefCategoryID) != nil {
                transactionsIncomes.append(transaction)
            }
        }
        return transactionsIncomes
    }
    
    //-------------------- amountIncomesByMonth() ----------------------
    // Description : Retourne la somme de toutes les transactions qui sont des revenus, pour un mois donné
    // Parameter : (month: Date)
    // Output : return [Transaction]
    // Extra : No
    //-----------------------------------------------------------
    public func amountIncomesByMonth(month: Date) -> Double {
        return getAllTransactionsIncomeForChosenMonth(selectedDate: month).map({ $0.amount }).reduce(0, +)
    }
    
} // End Extension Incomes

//MARK: - Extension Expenses
extension Account {
    
    //-------------------- amountOfExpensesInActualMonth() ----------------------
    // Description : Montant des dépenses sur le mois actuel
    // Parameter : No
    // Output : return Double
    // Extra : transactionsActualMonth = Account.transactionsActualMonth
    //-----------------------------------------------------------
    func amountOfExpensesInActualMonth() -> Double {
        var total: Double = 0
        for transaction in transactionsActualMonth {
            if transaction.amount < 0 { total -= transaction.amount }
        }
        return total
    }
    
    //-------------------- dailyAmountOfExpensesInActualMonth() ----------------------
    // Description : Montant des dépenses dans le mois actuel par jour
    // Parameter : No
    // Output : return [AmountOfTransactionsByDay]
    // Extra : transactionsActualMonth = Account.transactionsActualMonth
    //-----------------------------------------------------------
    func dailyAmountOfExpensesInActualMonth() -> [AmountOfTransactionsByDay] {
        var array: [AmountOfTransactionsByDay] = []
        let dates = Date().allDateOfMonth
        
        for date in dates {
            var amountOfDay: Double = 0.0
            
            for transaction in transactionsActualMonth {
                if Calendar.current.isDate(transaction.date.withDefault, inSameDayAs: date) && transaction.amount < 0 {
                    amountOfDay -= transaction.amount
                }
            }
            let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) // Bug date -1
            array.append(AmountOfTransactionsByDay(day: newDate!, amount: amountOfDay))
        }
    
        var sortedArray = array.sorted { $0.day < $1.day }
        sortedArray.removeLast() //One value too many
        
        return sortedArray
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
            if transaction.amount < 0 && Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month) {
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
    
} // End Extension Expenses

//MARK: - Extension CashFlow
extension Account {

    //-------------------- amountCashFlowByMonth() ----------------------
    // Description : Retourne la somme de toutes les transactions qui sont des dépenses et des revenus, pour un mois donné
    // Parameter : (month: Date)
    // Output : return [Transaction]
    // Extra : No
    //-----------------------------------------------------------
    func amountCashFlowByMonth(month: Date) -> Double {
        let amountOfExpenses = getAllExpensesTransactionsForChosenMonth(selectedDate: month).map({ $0.amount }).reduce(0, -)
        let amountOfIncomes = getAllTransactionsIncomeForChosenMonth(selectedDate: month).map({ $0.amount }).reduce(0, +)
        
        return amountOfExpenses + amountOfIncomes
    }
} //END Extension CashFlow

//MARK: - Extension Gain or Loss
extension Account {

    //-------------------- amountGainOrLossByMonth() ----------------------
    // Description : Calcule si des gains ou des pertes on était fait, pour un mois donné
    // Parameter : (month: Date)
    // Output : return [Transaction]
    // Extra : No
    //-----------------------------------------------------------
    func amountGainOrLossByMonth(month: Date) -> Double {
        let amountOfExpenses = getAllExpensesTransactionsForChosenMonth(selectedDate: month).map({ $0.amount }).reduce(0, +)
        let amountOfIncomes = getAllTransactionsIncomeForChosenMonth(selectedDate: month).map({ $0.amount }).reduce(0, +)
        
        return amountOfExpenses + amountOfIncomes
    }
} //END Extension CashFlow
