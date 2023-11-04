//
//  Subcategory Manager.swift
//  CashFlow
//
//  Created by Théo Sementa on 29/06/2023.
//

import Foundation

struct SubcategoryManager {
    
    //-------------------- subcategoryForSymbol ----------------------
    // Description : Récupère une sous-catégorie en fonction de son symbole.
    // Parameter : (subcategories: [Subcategory], symbol: String)
    // Output : return optional Subcategory
    // Extra : Renvoie nil si aucune sous-catégorie n'est trouvée avec le symbole donné.
    //-----------------------------------------------------------
    func subcategoryForSymbol(subcategories: [Subcategory], symbol: String) -> Subcategory? {
        for subcategory in subcategories {
            if subcategory.icon == symbol { return subcategory }
        }
        return nil
    }
    
    //-------------------- subcategoryForUniqueID ----------------------
    // Description : Récupère une sous-catégorie en fonction de son identifiant unique.
    // Parameter : (subcategories: [Subcategory], idUnique: String)
    // Output : return optional Subcategory
    // Extra : Renvoie nil si aucune sous-catégorie n'est trouvée avec l'identifiant unique donné.
    //-----------------------------------------------------------
    func subcategoryForUniqueID(subcategories: [Subcategory], idUnique: String) -> Subcategory? {
        for subcategory in subcategories {
            if subcategory.idUnique == idUnique { return subcategory }
        }
        return nil
    }
}
