//
//  TransactionDetailViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 28/10/2023.
//

import Foundation
import CoreData

class TransactionDetailViewModel: ObservableObject {
    static let shared = TransactionDetailViewModel()
    let context = persistenceController.container.viewContext
    
    @Published var selectedCategory: PredefinedCategory? = nil
    @Published var selectedSubcategory: PredefinedSubcategory? = nil
    
    @Published var mainAccount: Account? = nil
    
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
}

//MARK: - Utils
extension TransactionDetailViewModel {
    
    func changeCategory(transaction: Transaction) {
        if let selectedCategory, let newCategory = PredefinedCategoryManager().categoryByUniqueID(idUnique: selectedCategory.idUnique) {
            transaction.predefCategoryID = newCategory.idUnique
            transaction.predefSubcategoryID = ""
            PredefinedObjectManager.shared.addTransactionsToCategory()
            PredefinedObjectManager.shared.addTransactionsToSubcategory()
            if let selectedSubcategory, let newSubcategory = PredefinedSubcategoryManager().subcategoryByUniqueID(subcategories: newCategory.subcategories, idUnique: selectedSubcategory.idUnique) {
                transaction.predefSubcategoryID = newSubcategory.idUnique
                PredefinedObjectManager.shared.addTransactionsToSubcategory()
            }
            persistenceController.saveContext()
        }
    }
    
    func automaticCategorySearch(title: String) -> (PredefinedCategory?, PredefinedSubcategory?) {
        var arrayOfCandidate: [Transaction] = []

        if let account = mainAccount {
            for transaction in account.transactions {
                if transaction.title.lowercased().trimmingCharacters(in: .whitespaces).contains(title.lowercased().trimmingCharacters(in: .whitespaces)) && title.count > 3 {
                    arrayOfCandidate.append(transaction)
                }
            }
        }

        var categoryCount: [String: Int] = [:]

        for candidate in arrayOfCandidate {
            if candidate.predefCategoryID != "" {
                categoryCount[candidate.predefCategoryID, default: 0] += 1
            }
        }

        guard let mostCommonCategory = categoryCount.max(by: { $0.value < $1.value })?.key else {
            return (nil, nil)  // No categories found
        }

        let filteredTransactions = arrayOfCandidate.filter { $0.predefCategoryID == mostCommonCategory }
        
        guard !filteredTransactions.isEmpty else {
            return (nil, nil)  // No transactions found for the most common category
        }
        
        let sortedTransactions = filteredTransactions.sorted { $0.date > $1.date }
        
        let mostRecentTransaction = sortedTransactions.first!
        
        let finalCategory = PredefinedCategoryManager().categoryByUniqueID(idUnique: mostRecentTransaction.predefCategoryID)
        let finalSubcategory = PredefinedSubcategoryManager().subcategoryByUniqueID(subcategories: finalCategory?.subcategories ?? [], idUnique: mostRecentTransaction.predefSubcategoryID)
        
        return (finalCategory, finalSubcategory)
    }
    
    func resetData() {

    }
    
}
