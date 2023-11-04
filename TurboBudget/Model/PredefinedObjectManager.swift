//
//  PredefinedCategoryManager.swift
//  CashFlow
//
//  Created by KaayZenn on 07/10/2023.
//

import Foundation
import CoreData

class PredefinedObjectManager: ObservableObject {
    static let shared = PredefinedObjectManager()
    
    @Published var allPredefinedCategory: [PredefinedCategory] = []
    
    private init() {
        addSubcategoriesToCategory()
        loadCategory()
        addTransactionsToCategory()
        addTransactionsArchivedToCategory()
        addTransactionsToSubcategory()
        addBudgetToSubcategory()
    }
    
    // MARK: - For init
    func loadCategory() {
        allPredefinedCategory = [
            categoryPredefined00,
            categoryPredefined0,
            categoryPredefined1,
            categoryPredefined2,
            categoryPredefined3,
            categoryPredefined4,
            categoryPredefined5,
            categoryPredefined6,
            categoryPredefined7,
            categoryPredefined8,
            categoryPredefined9,
            categoryPredefined10,
            categoryPredefined11,
            categoryPredefined12
        ]
    }
    
    func addSubcategoriesToCategory() {
        categoryPredefined00.subcategories = [ 
        ]
        categoryPredefined1.subcategories = [ // 1. Achats & Shopping
            subCategory1Category1,
            subCategory2Category1,
            subCategory3Category1,
            subCategory4Category1,
            subCategory5Category1,
            subCategory6Category1,
            subCategory7Category1,
            subCategory8Category1,
            subCategory9Category1,
            subCategory10Category1,
        ]
        categoryPredefined2.subcategories = [ // 2. Alimentation & Restaurants
            subCategory1Category2,
            subCategory2Category2,
            subCategory3Category2,
            subCategory4Category2,
            subCategory5Category2
        ]
        categoryPredefined3.subcategories = [ // 3. Animaux
            subCategory1Category3,
            subCategory2Category3,
            subCategory3Category3,
            subCategory4Category3,
            subCategory5Category3
        ]
        categoryPredefined4.subcategories = [ // 4. Crédits
        ]
        categoryPredefined5.subcategories = [ // 5. Épargne & Placements
        ]
        categoryPredefined6.subcategories = [ // 6. Impôts, Taxes & Frais
            subCategory1Category6,
            subCategory2Category6,
            subCategory3Category6,
            subCategory4Category6,
            subCategory5Category6,
            subCategory6Category6,
            subCategory7Category6
        ]
        categoryPredefined7.subcategories = [ // 7. Logement & Charges
            subCategory1Category7,
            subCategory2Category7,
            subCategory3Category7,
            subCategory4Category7,
            subCategory5Category7,
            subCategory6Category7,
            subCategory7Category7,
            subCategory8Category7,
            subCategory9Category7
        ]
        categoryPredefined8.subcategories = [ // 8. Loisirs & vacances
            subCategory1Category8,
            subCategory2Category8,
            subCategory3Category8,
            subCategory4Category8,
            subCategory5Category8,
            subCategory6Category8,
            subCategory7Category8
        ]
        categoryPredefined9.subcategories = [ // 9. Retraits
        ]
        categoryPredefined10.subcategories = [ // 10. Santé
            subCategory1Category10,
            subCategory2Category10,
            subCategory3Category10,
            subCategory4Category10,
            subCategory5Category10
        ]
        categoryPredefined11.subcategories = [ // 11. Transport
            subCategory1Category11,
            subCategory2Category11,
            subCategory3Category11,
            subCategory4Category11,
            subCategory5Category11,
            subCategory6Category11,
            subCategory7Category11,
            subCategory8Category11,
            subCategory9Category11,
            subCategory10Category11,
            subCategory11Category11
        ]
        categoryPredefined12.subcategories = [ // 12. Travail & Études
            subCategory1Category12,
            subCategory2Category12,
            subCategory3Category12,
            subCategory4Category12,
            subCategory5Category12
        ]
    }
    
    func addTransactionsToCategory() {
        print("🔥 ADD TRANSACTIONS TO CATEGORY")
        for index in allPredefinedCategory.indices {
            allPredefinedCategory[index].transactions = PredefinedCategoryManager().findTransactionsForCategory(categoryUniqueID: allPredefinedCategory[index].idUnique)
        }
    }
    
    func addTransactionsArchivedToCategory() {
        print("🔥 ADD TRANSACTIONS ARCHIVED TO CATEGORY")
        for index in allPredefinedCategory.indices {
            allPredefinedCategory[index].transactionsArchived = PredefinedCategoryManager().findTransactionsArchivedForCategory(categoryUniqueID: allPredefinedCategory[index].idUnique)
        }
    }
    
    func addTransactionsToSubcategory() {
        print("🔥 ADD TRANSACTIONS TO SUBCATEGORY")
        for indexCat in allPredefinedCategory.indices {
            for indexSub in allPredefinedCategory[indexCat].subcategories.indices {
                allPredefinedCategory[indexCat].subcategories[indexSub].transactions = []
                allPredefinedCategory[indexCat].subcategories[indexSub].transactions = PredefinedSubcategoryManager().findTransactionsForSubcategory(subcategoryUniqueID: allPredefinedCategory[indexCat].subcategories[indexSub].idUnique)
            }
        }
    }
    
    func reloadTransactions() {
        addTransactionsToCategory()
        addTransactionsArchivedToCategory()
        addTransactionsToSubcategory()
    }
    
    func addBudgetToSubcategory() {
        for indexCat in allPredefinedCategory.indices {
            for indexSub in allPredefinedCategory[indexCat].subcategories.indices {
                allPredefinedCategory[indexCat].subcategories[indexSub].budget = BudgetManager().findBudgetForSubcategory(subcategoryUniqueID: allPredefinedCategory[indexCat].subcategories[indexSub].idUnique)
            }
        }
    }
    
}
