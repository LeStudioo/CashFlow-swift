//
//  AddTransactionViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 26/10/2023.
//

import Foundation
import CoreData
import SwiftUI

class AddTransactionViewModel: ObservableObject {
    static let shared = AddTransactionViewModel()
    let context = persistenceController.container.viewContext
    var predefinedObjectManager = PredefinedObjectManager.shared
    
    @Published var transactionTitle: String = ""
    @Published var transactionAmount: Double = 0
    @Published var transactionType: ExpenseOrIncome = .expense
    @Published var transactionDate: Date = Date()
    @Published var selectedCategory: PredefinedCategory? = nil
    @Published var selectedSubcategory: PredefinedSubcategory? = nil
    
    @Published var theNewTransaction: Transaction? = nil
    
    @Published var mainAccount: Account? = nil
    
    @Published var presentingConfirmationDialog: Bool = false
    
    // Prefrences
    @Preference(\.cardLimitPercentage) private var cardLimitPercentage
    @Preference(\.budgetPercentage) private var budgetPercentage
    @Preference(\.accountCanBeNegative) private var accountCanBeNegative
    @Preference(\.blockExpensesIfCardLimitExceeds) private var blockExpensesIfCardLimitExceeds
    @Preference(\.blockExpensesIfBudgetAmountExceeds) private var blockExpensesIfBudgetAmountExceeds
    @Preference(\.isSearchDuplicateEnabled) private var isSearchDuplicateEnabled
    
    // Alerts
    @Published var isCardLimitSoonToBeExceeded: Bool = false
    @Published var isCardLimitExceeded: Bool = false
    @Published var isBudgetSoonToBeExceeded: Bool = false
    @Published var isBudgetExceed: Bool = false
    
    @Published var showSuccessfulTransaction: Bool = false
    
    // init
    init() {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        var allAccount: [Account] = []
        do {
            allAccount = try context.fetch(fetchRequest)
            if allAccount.count != 0 {
                mainAccount = allAccount[0]
            }
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    func makeScannerView() -> ScannerTicketView {
        ScannerTicketView { amount, date, errorMessage in
            if let amount { self.transactionAmount = amount }
            if let date { self.transactionDate = date }
        }
    }
    
    //-------------------- createNewTransaction ----------------------
    // Description : Create a new transaction
    // Parameter : No
    // Output : Void
    // Extra :
    //-----------------------------------------------------------
    func createNewTransaction() {
        if let mainAccount {
            let newTransaction = Transaction(context: context)
            newTransaction.id = UUID()
            newTransaction.title = transactionTitle.trimmingCharacters(in: .whitespaces)
            newTransaction.amount = transactionType == .expense ? -transactionAmount : transactionAmount
            newTransaction.date = transactionDate
            newTransaction.creationDate = Date()
            newTransaction.comeFromAuto = false
            newTransaction.predefCategoryID = transactionType == .income ? categoryPredefined0.idUnique : selectedCategory?.idUnique ?? ""
            newTransaction.predefSubcategoryID = transactionType == .income ? "" : selectedSubcategory?.idUnique ?? ""
            
            mainAccount.addNewTransaction(transaction: newTransaction)
                        
            // Card Limit
            if mainAccount.cardLimit != 0 {
                let percentage = mainAccount.amountOfExpensesInActualMonth() / Double(mainAccount.cardLimit)
                if percentage >= cardLimitPercentage / 100 && percentage <= 1 { isCardLimitSoonToBeExceeded = true }
                if percentage > 1 { isCardLimitExceeded = true }
            }
            
            // Budget
            if let selectedSubcategory, let budget = selectedSubcategory.budget {
                let percentage = budget.actualAmountForMonth(month: .now) / budget.amount
                if percentage >= budgetPercentage / 100 && percentage <= 1 {
                    isBudgetSoonToBeExceeded = true
                }
                if percentage > 1 { isBudgetExceed = true }
            }
            
            do {
                try context.save()
                print("🔥 New Transaction created with Success")
                theNewTransaction = newTransaction
                predefinedObjectManager.reloadTransactions()
                withAnimation { showSuccessfulTransaction.toggle() }
            } catch {
                print("⚠️ Error for : \(error.localizedDescription)")
            }
        }
    }
    
}

//MARK: - Utils
extension AddTransactionViewModel {
    
    func automaticCategorySearch() -> (PredefinedCategory?, PredefinedSubcategory?) {
        var arrayOfCandidate: [Transaction] = []

        if let account = mainAccount {
            for transaction in account.transactions {
                if transaction.title.lowercased().trimmingCharacters(in: .whitespaces).contains(transactionTitle.lowercased().trimmingCharacters(in: .whitespaces)) && transactionTitle.count > 3 {
                    arrayOfCandidate.append(transaction)
                }
            }
        }

        // Au lieu de compter les catégories, créez un dictionnaire pour stocker la transaction la plus récente de chaque catégorie
        var mostRecentTransactionByCategory: [String: Transaction] = [:]

        for candidate in arrayOfCandidate {
            if candidate.predefCategoryID != "" && candidate.predefCategoryID != categoryPredefined0.idUnique && candidate.predefCategoryID != categoryPredefined00.idUnique {
                // Vérifier si la transaction actuelle est plus récente que celle stockée
                if let existingTransaction = mostRecentTransactionByCategory[candidate.predefCategoryID], existingTransaction.date < candidate.date {
                    mostRecentTransactionByCategory[candidate.predefCategoryID] = candidate
                } else if mostRecentTransactionByCategory[candidate.predefCategoryID] == nil {
                    mostRecentTransactionByCategory[candidate.predefCategoryID] = candidate
                }
            }
        }

        // Trouvez la transaction la plus récente toutes catégories confondues
        guard let mostRecentTransaction = mostRecentTransactionByCategory.values.sorted(by: { $0.date > $1.date }).first else {
            return (nil, nil)  // No transactions found
        }

        let finalCategory = PredefinedCategoryManager().categoryByUniqueID(idUnique: mostRecentTransaction.predefCategoryID)
        let finalSubcategory = PredefinedSubcategoryManager().subcategoryByUniqueID(subcategories: finalCategory?.subcategories ?? [], idUnique: mostRecentTransaction.predefSubcategoryID)
        
        return (finalCategory, finalSubcategory)
    }

    
    func resetData() {
        transactionTitle = ""
        transactionAmount = 0.0
        transactionType = .expense
        transactionDate = Date()
        selectedCategory = nil
        selectedSubcategory = nil
        
        theNewTransaction = nil
                
        // Alerts
        isCardLimitSoonToBeExceeded = false
        isCardLimitExceeded = false
        isBudgetSoonToBeExceeded = false
        isBudgetExceed = false
        
        showSuccessfulTransaction = false
    }
    
}

//MARK: - Verification
extension AddTransactionViewModel {
    
    func isTransactionInCreation() -> Bool {
        if selectedCategory != nil || selectedSubcategory != nil || !transactionTitle.isEmpty || transactionAmount != 0 {
            return true
        }
        return false
    }
    
    var isAccountWillBeNegative: Bool {
        if let mainAccount, !accountCanBeNegative {
            if mainAccount.balance - transactionAmount < 0 && transactionType == .expense { return true } else { return false }
        } else { return false }
    }
    
    var isCardLimitExceeds: Bool {
        if let mainAccount, mainAccount.cardLimit != 0, blockExpensesIfCardLimitExceeds, transactionType == .expense {
            let cardLimitAfterTransaction = mainAccount.amountOfExpensesInActualMonth() + transactionAmount
            if cardLimitAfterTransaction <= mainAccount.cardLimit { return false } else { return true }
        } else { return false }
    }
    
    var isBudgetIsExceededAfterThisTransaction: Bool {
        if let selectedSubcategory, blockExpensesIfBudgetAmountExceeds {
            if let budget = selectedSubcategory.budget {
                if budget.isExceeded(month: transactionDate) { return true }
                if (budget.actualAmountForMonth(month: transactionDate) + transactionAmount) > budget.amount { return true }
            }
        }
        return false
    }
    
    var isDuplicateTransactions: Bool {
        if let mainAccount, isSearchDuplicateEnabled, transactionType == .expense {
            let accountFilteredByTitle = mainAccount.allTransactions.filter { $0.title == transactionTitle }
            let accountFilteredBySubcategory = accountFilteredByTitle.filter { $0.predefSubcategoryID == selectedSubcategory?.idUnique ?? "" && selectedSubcategory != nil }
            if accountFilteredBySubcategory.count != 0 { return true } else { return false }
        } else { return false }
    }
    
    var numberOfAlerts: Int {
        var num: Int = 0
        if isCardLimitExceeds { num += 1 }
        if isAccountWillBeNegative { num += 1 }
        if isBudgetIsExceededAfterThisTransaction { num += 1 }
        if isDuplicateTransactions { num += 1}
        return num
    }
    
    var numberOfAlertsForSuccessful: Int {
        var num: Int = 0
        if isCardLimitSoonToBeExceeded { num += 1 }
        if let mainAccount { if mainAccount.amountOfExpensesInActualMonth() > mainAccount.cardLimit && mainAccount.cardLimit != 0 { num += 1 } }
        if isBudgetSoonToBeExceeded { num += 1 }
        if isBudgetExceed { num += 1 }
        return num
    }
    
    func validateTrasaction() -> Bool {
        if isAccountWillBeNegative { return false }
        
        if transactionType == .income && !transactionTitle.isEmptyWithoutSpace() && transactionAmount != 0.0 { return true }
        
        if blockExpensesIfCardLimitExceeds && transactionType == .expense {
            if !transactionTitle.isEmptyWithoutSpace() && transactionAmount != 0.0 && selectedCategory != nil && !isCardLimitExceeds && !isBudgetIsExceededAfterThisTransaction {
                return true
            }
        } else if !transactionTitle.isEmptyWithoutSpace() && transactionAmount != 0.0 && selectedCategory != nil && !isBudgetIsExceededAfterThisTransaction {
            return true
        }
        return false
    }
}
