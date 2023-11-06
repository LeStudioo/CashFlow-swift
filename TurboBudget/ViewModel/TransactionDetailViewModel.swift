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

    }
    
}
