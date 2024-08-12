////
////  PredefinedSubcategoryManager.swift
////  CashFlow
////
////  Created by KaayZenn on 07/10/2023.
////
//
//import Foundation
//import CoreData
//
//struct PredefinedSubcategoryManager {
//    
//    //-------------------- subcategoryForSymbol ----------------------
//    // Description : Récupère une sous-catégorie en fonction de son symbole.
//    // Parameter : (subcategories: [Subcategory], symbol: String)
//    // Output : return optional Subcategory
//    // Extra : Renvoie nil si aucune sous-catégorie n'est trouvée avec le symbole donné.
//    //-----------------------------------------------------------
//    func subcategoryForSymbol(subcategories: [PredefinedSubcategory], symbol: String) -> PredefinedSubcategory? {
//        for subcategory in subcategories {
//            if subcategory.icon == symbol { return subcategory }
//        }
//        return nil
//    }
//    
//    //-------------------- subcategoryByUniqueID ----------------------
//    // Description : Récupère une sous-catégorie en fonction de son identifiant unique.
//    // Parameter : (subcategories: [Subcategory], idUnique: String)
//    // Output : return optional Subcategory
//    // Extra : Renvoie nil si aucune sous-catégorie n'est trouvée avec l'identifiant unique donné.
//    //-----------------------------------------------------------
//    func subcategoryByUniqueID(subcategories: [PredefinedSubcategory], idUnique: String) -> PredefinedSubcategory? {
//        for subcategory in subcategories {
//            if subcategory.idUnique == idUnique { return subcategory }
//        }
//        return nil
//    }
//}
//
//extension PredefinedSubcategoryManager {
//    func findTransactionsForSubcategory(subcategoryUniqueID: String) -> [Transaction] {
//        let context = persistenceController.container.viewContext
//        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
//        var allTransactions: [Transaction] = []
//        var allFinalTransactions: [Transaction] = []
//        do {
//            allTransactions = try context.fetch(fetchRequest)
//        } catch {
//            print("⚠️ Error for : \(error.localizedDescription)")
//        }
//        
//        for transaction in allTransactions {
//            if transaction.predefSubcategoryID == subcategoryUniqueID {
//                allFinalTransactions.append(transaction)
//            }
//        }
//        return allFinalTransactions.sorted { $0.date > $1.date }.filter { !$0.isAuto && $0.predefCategoryID != "" }
//    }
//}
