//
//  SubscriptionDetailViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/12/2024.
//

import Foundation

extension SubscriptionDetailsScreen {
    
    final class ViewModel: ObservableObject {
        @Published var selectedCategory: CategoryModel?
        @Published var selectedSubcategory: SubcategoryModel?
    }
    
}

extension SubscriptionDetailsScreen.ViewModel {
    
    @MainActor
    func updateCategory(subscriptionID: Int) {
        let subscriptionStore: SubscriptionStore = .shared
        
        var body: SubscriptionDTO = .init()
        
        if let selectedCategory, let newCategory = CategoryStore.shared.findCategoryById(selectedCategory.id) {
            body.categoryID = newCategory.id
            body.subcategoryID = nil
            
            if newCategory.id == 0 {
                selectedSubcategory = nil
            }
            
            if let selectedSubcategory, let newSubcategory = CategoryStore.shared.findSubcategoryById(selectedSubcategory.id) {
                body.subcategoryID = newSubcategory.id
            }
            
            Task {
                await subscriptionStore.updateSubscription(
                    subscriptionID: subscriptionID,
                    body: body
                )
                
                self.selectedCategory = nil
                self.selectedSubcategory = nil
            }
        }
    }
    
}
