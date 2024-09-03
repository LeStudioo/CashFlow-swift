//
//  TransactionDetailViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 28/10/2023.
//

import Foundation
import CoreData

class TransactionDetailViewModel: ObservableObject {    
    @Published var selectedCategory: PredefinedCategory? = nil
    @Published var selectedSubcategory: PredefinedSubcategory? = nil
}

//MARK: - Utils
extension TransactionDetailViewModel {
    
    // TODO: Refaire
    func changeCategory(transaction: TransactionEntity) {
        if let selectedCategory, let newCategory = PredefinedCategory.findByID(selectedCategory.id) {
            transaction.predefCategoryID = newCategory.id
            transaction.predefSubcategoryID = ""
            // TODO: Voir si auto update
//            PredefinedObjectManager.shared.addTransactionsToCategory()
//            PredefinedObjectManager.shared.addTransactionsToSubcategory()
            if let selectedSubcategory, let newSubcategory = newCategory.subcategories.findByID(selectedSubcategory.id) {
                transaction.predefSubcategoryID = newSubcategory.id
                // TODO: Voir si auto update
//                PredefinedObjectManager.shared.addTransactionsToSubcategory()
            }
            persistenceController.saveContext()
        }
    }
    
}
