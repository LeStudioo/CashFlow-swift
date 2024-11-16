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
        let calendar = Calendar.current
        var finalDate: Date
        
        if automationFrenquently == .monthly {
            var comps = calendar.dateComponents([.day, .month, .year], from: Date())
            comps.day = dayAutomation
            finalDate = calendar.date(from: comps) ?? .now
            
            if Date().day > dayAutomation {
                finalDate = calendar.date(byAdding: .month, value: 1, to: finalDate) ?? .now
            }
        } else {
            finalDate = dateAutomation
        }
        
        let transactionModel = TransactionModelOld(
            predefCategoryID: transactionType == .income ? PredefinedCategory.PREDEFCAT0.id : selectedCategory?.id ?? "",
            predefSubcategoryID: transactionType == .income ? "" : selectedSubcategory?.id ?? "",
            title: transactionTitle,
            amount: transactionType == .expense ? -transactionAmount.toDouble() : transactionAmount.toDouble(),
            date: finalDate,
            isAuto: true
        )
        
        var automationModel = AutomationModel(
            title: transactionTitle,
            date: finalDate,
            frenquently: automationFrenquently == .monthly ? 0 : 1
        )
        
        do {
            let newTransaction = try TransactionRepositoryOld.shared.createNewTransaction(model: transactionModel, withSave: false)
            automationModel.transaction = newTransaction
            
            let newAutomation = try AutomationRepositoryOld.shared.createAutomation(model: automationModel, withSave: false)
            newTransaction.transactionToAutomation = newAutomation
            
            try viewContext.save()
            AutomationRepositoryOld.shared.automations.append(newAutomation)
            withError(nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.successfullModalManager.isPresenting = true
            }
            successfullModalManager.title = "automation_successful".localized
            successfullModalManager.subtitle = "automation_successful_desc".localized
            successfullModalManager.content = AnyView(CellTransactionWithoutAction(transaction: newTransaction))
        } catch {
            if let error = error as? CustomError {
                withError(error)
            }
        }
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
