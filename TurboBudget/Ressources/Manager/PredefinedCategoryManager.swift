//
//  PredefinedCategoryManager.swift
//  CashFlow
//
//  Created by KaayZenn on 07/10/2023.
//

import Foundation
import CoreData

class PredefinedCategoryManager {
    
    //-------------------- categoryForSymbol ----------------------
    // Description : Récupère une catégorie en fonction de son symbole.
    // Parameter : (categories: [PredefinedCategory], symbol: String)
    // Output : return optional PredefinedCategory
    // Extra : Renvoie nil si aucune catégorie n'est trouvée avec le symbole donné.
    //-----------------------------------------------------------
    func categoryBySymbol(symbol: String) -> PredefinedCategory? {
        for category in PredefinedObjectManager.shared.allPredefinedCategory {
            if category.icon == symbol { return category }
        }
        return nil
    }
    
    //-------------------- categoryByUniqueID ----------------------
    // Description : Récupère une catégorie en fonction de son identifiant unique.
    // Parameter : (subcategories: [category], idUnique: String)
    // Output : return optional Subcategory
    // Extra : Renvoie nil si aucune sous-catégorie n'est trouvée avec l'identifiant unique donné.
    //-----------------------------------------------------------
    func categoryByUniqueID(idUnique: String) -> PredefinedCategory? {
        for category in PredefinedObjectManager.shared.allPredefinedCategory {
            if category.idUnique == idUnique { return category }
        }
        return nil
    }
    
    func getAllCategoriesForTransactions() -> [PredefinedCategory] {
        var array: [PredefinedCategory] = []
        for category in PredefinedObjectManager.shared.allPredefinedCategory {
            if category.transactions.count != 0 { array.append(category) }
        }
        return array.sorted { $0.title < $1.title }
    }
    
    func getAllCategoriesForTransactionsArchived() -> [PredefinedCategory] {
        var array: [PredefinedCategory] = []
        for category in PredefinedObjectManager.shared.allPredefinedCategory {
            if category.transactionsArchived.count != 0 { array.append(category) }
        }
        return array.sorted { $0.title < $1.title }
    }
    
    func getAllCategoriesForTransactionsWithOnlyAutomations() -> [PredefinedCategory] {
        var array: [PredefinedCategory] = []
        for category in PredefinedObjectManager.shared.allPredefinedCategory {
            if category.transactionsWithOnlyAutomations().count != 0 { array.append(category) }
        }
        return array.sorted { $0.title < $1.title }
    }
    
    func findTransactionsForCategory(categoryUniqueID: String) -> [Transaction] {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        var allTransactions: [Transaction] = []
        var allFinalTransactions: [Transaction] = []
        do {
            allTransactions = try context.fetch(fetchRequest)
        } catch {
            print("⚠️ Error for : \(error.localizedDescription)")
        }
        
        for transaction in allTransactions {
            if transaction.predefCategoryID == categoryUniqueID {
                allFinalTransactions.append(transaction)
            }
        }
        return allFinalTransactions.sorted { $0.date > $1.date }.filter { !$0.isAuto && $0.predefCategoryID != "" }
    }
    
    func findTransactionsArchivedForCategory(categoryUniqueID: String) -> [Transaction] {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        var allTransactions: [Transaction] = []
        var allFinalTransactions: [Transaction] = []
        do {
            allTransactions = try context.fetch(fetchRequest)
        } catch {
            print("⚠️ Error for : \(error.localizedDescription)")
        }
        
        for transaction in allTransactions {
            if transaction.predefCategoryID == categoryUniqueID {
                allFinalTransactions.append(transaction)
            }
        }
        return allFinalTransactions.sorted { $0.date > $1.date }.filter { !$0.isAuto && $0.predefCategoryID != "" && $0.isArchived }
    }
}
