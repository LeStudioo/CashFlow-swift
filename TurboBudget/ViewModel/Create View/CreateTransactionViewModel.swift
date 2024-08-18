//
//  CreateTransactionViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 26/10/2023.
//

import Foundation
import SwiftUI

final class CreateTransactionViewModel: ObservableObject {
    static let shared = CreateTransactionViewModel()
    let successfullModalManager = SuccessfullModalManager.shared
    
    @Published var transactionTitle: String = ""
    @Published var transactionAmount: String = ""
    @Published var transactionType: ExpenseOrIncome = .expense
    @Published var transactionDate: Date = Date()
    @Published var selectedCategory: PredefinedCategory? = nil
    @Published var selectedSubcategory: PredefinedSubcategory? = nil
            
    @Published var presentingConfirmationDialog: Bool = false
    
    // Prefrences
    @Preference(\.accountCanBeNegative) private var accountCanBeNegative
    @Preference(\.blockExpensesIfCardLimitExceeds) private var blockExpensesIfCardLimitExceeds
    @Preference(\.blockExpensesIfBudgetAmountExceeds) private var blockExpensesIfBudgetAmountExceeds
    @Preference(\.isSearchDuplicateEnabled) private var isSearchDuplicateEnabled
    
    // Alerts
    @Published var isCardLimitSoonToBeExceeded: Bool = false
    @Published var isCardLimitExceeded: Bool = false
    @Published var isBudgetSoonToBeExceeded: Bool = false
    @Published var isBudgetExceed: Bool = false
        
    func makeScannerView() -> ScannerTicketView {
        ScannerTicketView { amount, date, errorMessage in
            if let amount { self.transactionAmount = String(amount) }
            if let date { self.transactionDate = date }
        }
    }
    
    func createNewTransaction(withError: @escaping (_ withError: CustomError?) -> Void) {
        guard let account = AccountRepository.shared.mainAccount else { return }
        
        let model = TransactionModel(
            predefCategoryID: transactionType == .income ? PredefinedCategory.PREDEFCAT0.id : selectedCategory?.id ?? "",
            predefSubcategoryID: transactionType == .income ? "" : selectedSubcategory?.id ?? "",
            title: transactionTitle.trimmingCharacters(in: .whitespaces),
            amount: transactionType == .expense ? -transactionAmount.convertToDouble() : transactionAmount.convertToDouble(),
            date: transactionDate
        )
        
        do {
            let newTransaction = try TransactionRepository.shared.createNewTransaction(model: model)
            account.balance += model.amount
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.successfullModalManager.isPresenting = true
            }
            successfullModalManager.title = "transaction_successful".localized
            successfullModalManager.subtitle = "transaction_successful_desc".localized
            successfullModalManager.content = AnyView(CellTransactionWithoutAction(transaction: newTransaction))
        } catch {
            if let error = error as? CustomError {
                withError(error)
            }
        }
    }
        
}

//MARK: - Utils
extension CreateTransactionViewModel {
    
    func automaticCategorySearch() -> (PredefinedCategory?, PredefinedSubcategory?) {
        var arrayOfCandidate: [Transaction] = []

        if let account = AccountRepository.shared.mainAccount {
            for transaction in account.transactions {
                if transaction.title
                    .lowercased()
                    .trimmingCharacters(in: .whitespaces)
                    .contains(transactionTitle
                        .lowercased()
                        .trimmingCharacters(in: .whitespaces)
                    ) && transactionTitle.count > 3 {
                    arrayOfCandidate.append(transaction)
                }
            }
        }

        // Au lieu de compter les catégories, créez un dictionnaire pour stocker la transaction la plus récente de chaque catégorie
        var mostRecentTransactionByCategory: [String: Transaction] = [:]

        for candidate in arrayOfCandidate {
            if !candidate.predefCategoryID.isEmpty 
                && candidate.predefCategoryID != PredefinedCategory.PREDEFCAT0.id
                && candidate.predefCategoryID != PredefinedCategory.PREDEFCAT00.id {
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

        guard let finalCategory = PredefinedCategory.findByID(mostRecentTransaction.predefCategoryID) else {
            return (nil, nil)
        }
        let finalSubcategory = finalCategory.subcategories.findByID(mostRecentTransaction.predefSubcategoryID)
        
        return (finalCategory, finalSubcategory)
    }

    
    func resetData() {
        transactionTitle = ""
        transactionAmount = ""
        transactionType = .expense
        transactionDate = Date()
        selectedCategory = nil
        selectedSubcategory = nil
                        
        // Alerts
        isCardLimitSoonToBeExceeded = false
        isCardLimitExceeded = false
        isBudgetSoonToBeExceeded = false
        isBudgetExceed = false
    }
    
}

//MARK: - Verification
extension CreateTransactionViewModel {
    
    func isTransactionInCreation() -> Bool {
        if selectedCategory != nil || selectedSubcategory != nil || !transactionTitle.isEmpty || transactionAmount.convertToDouble() != 0 {
            return true
        }
        return false
    }
    
    var isAccountWillBeNegative: Bool {
        if let mainAccount = AccountRepository.shared.mainAccount, !accountCanBeNegative {
            if mainAccount.balance - transactionAmount.convertToDouble() < 0 && transactionType == .expense { return true } else { return false }
        } else { return false }
    }
    
    var isCardLimitExceeds: Bool {
        if let mainAccount = AccountRepository.shared.mainAccount, mainAccount.cardLimit != 0, blockExpensesIfCardLimitExceeds, transactionType == .expense {
            let cardLimitAfterTransaction = mainAccount.amountOfExpensesInActualMonth() + transactionAmount.convertToDouble()
            if cardLimitAfterTransaction <= mainAccount.cardLimit { return false } else { return true }
        } else { return false }
    }
    
    var isBudgetIsExceededAfterThisTransaction: Bool {
        if let selectedSubcategory, blockExpensesIfBudgetAmountExceeds {
            if let budget = selectedSubcategory.budget {
                if budget.isExceeded(month: transactionDate) { return true }
                if (budget.actualAmountForMonth(month: transactionDate) + transactionAmount.convertToDouble()) > budget.amount { return true }
            }
            return false
        }
        return false
    }
    
    var isDuplicateTransactions: Bool {
        if let mainAccount = AccountRepository.shared.mainAccount, isSearchDuplicateEnabled, transactionType == .expense {
            let accountFilteredByTitle = mainAccount.allTransactions.filter { $0.title == transactionTitle }
            let accountFilteredBySubcategory = accountFilteredByTitle.filter { $0.predefSubcategoryID == selectedSubcategory?.id ?? "" && selectedSubcategory != nil }
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
        if let mainAccount = AccountRepository.shared.mainAccount { if mainAccount.amountOfExpensesInActualMonth() > mainAccount.cardLimit && mainAccount.cardLimit != 0 { num += 1 } }
        if isBudgetSoonToBeExceeded { num += 1 }
        if isBudgetExceed { num += 1 }
        return num
    }
    
    func validateTrasaction() -> Bool {
        if isAccountWillBeNegative { return false }
        
        if transactionType == .income && !transactionTitle.isEmptyWithoutSpace() && transactionAmount.convertToDouble() != 0.0 { return true }

        
        if blockExpensesIfCardLimitExceeds && transactionType == .expense {
            if !transactionTitle.isEmptyWithoutSpace() && transactionAmount.convertToDouble() != 0.0 && selectedCategory != nil && !isCardLimitExceeds && !isBudgetIsExceededAfterThisTransaction {
                return true
            }
        } else if !transactionTitle.isEmptyWithoutSpace() && transactionAmount.convertToDouble() != 0.0 && selectedCategory != nil && !isBudgetIsExceededAfterThisTransaction {
            return true
        }
        return false
    }
}
