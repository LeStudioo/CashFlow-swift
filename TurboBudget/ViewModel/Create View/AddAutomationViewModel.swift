//
//  AddAutomationViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 02/11/2023.
//

import Foundation
import SwiftUI

enum AutomationFrequently: CaseIterable {
    case monthly, yearly
}

class AddAutomationViewModel: ObservableObject {
    static let shared = AddAutomationViewModel()
    let successfullModalManager: SuccessfullModalManager = .shared
    
    @Published var selectedCategory: PredefinedCategory? = nil
    @Published var selectedSubcategory: PredefinedSubcategory? = nil
    @Published var transactionTitle: String = ""
    @Published var transactionAmount: String = ""
    @Published var dayAutomation: Int = 1
    @Published var dateAutomation: Date = .now
    @Published var transactionType: ExpenseOrIncome = .expense
    @Published var automationFrenquently: AutomationFrequently = .monthly
        
    @Published var presentingConfirmationDialog: Bool = false
    
    init() {
        let comps = Calendar.current.dateComponents([.day], from: Date())
        if let day = comps.day { dayAutomation = day }
    }

}

extension AddAutomationViewModel {
    
    func createNewAutomation() {
        
    }
    
    func createNewAutomation(withError: @escaping (_ withError: CustomError?) -> Void) { 
       
    }
        
}

// MARK: - Verification
extension AddAutomationViewModel {
    
    func isAutomationInCreation() -> Bool {
        if selectedCategory != nil || selectedSubcategory != nil || !transactionTitle.isEmpty || transactionAmount.toDouble() != 0 {
            return true
        }
        return false
    }
    
    func validateAutomation() -> Bool {
        if !transactionTitle.isBlank && transactionAmount.toDouble() != 0.0 && selectedCategory != nil {
            return true
        }
        return false
    }
}
