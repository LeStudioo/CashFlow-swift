//
//  AddAutomationViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 02/11/2023.
//

import Foundation
import CoreData
import SwiftUI

enum AutomationFrequently: CaseIterable {
    case monthly, yearly
}

class AddAutomationViewModel: ObservableObject {
    static let shared = AddAutomationViewModel()
    let viewContext = persistenceController.container.viewContext
    
    @Published var selectedCategory: PredefinedCategory? = nil
    @Published var selectedSubcategory: PredefinedSubcategory? = nil
    @Published var titleTransaction: String = ""
    @Published var amountTransaction: String = ""
    @Published var dayAutomation: Int = 1
    @Published var dateAutomation: Date = .now
    @Published var typeTransaction: ExpenseOrIncome = .expense
    @Published var automationFrenquently: AutomationFrequently = .monthly
    
    @Published var showSuccessfulAutomation: Bool = false
    @Published var allowNotification: Bool = false
    @Published var addNotification: Bool = false
    
    @Published var mainAccount: Account? = nil
    @Published var theNewTransaction: Transaction? = nil
    @Published var theNewAutomation: Automation? = nil
    @Published var presentingConfirmationDialog: Bool = false
    
    // init
    init() {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        var allAccount: [Account] = []
        do {
            allAccount = try viewContext.fetch(fetchRequest)
            if allAccount.count != 0 {
                mainAccount = allAccount[0]
            }
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
}

extension AddAutomationViewModel {
    
    func createNewAutomation() {
        
        let finalDate: Date
        if automationFrenquently == .monthly {
            var comps = Calendar.current.dateComponents([.day, .month, .year], from: Date())
            comps.day = dayAutomation
            finalDate = Calendar.current.date(from: comps) ?? .now
        } else {
            finalDate = dateAutomation
        }
        
        let newTransaction = Transaction(context: viewContext)
        newTransaction.id = UUID()
        newTransaction.title = titleTransaction
        newTransaction.amount = typeTransaction == .expense ? -amountTransaction.convertToDouble() : amountTransaction.convertToDouble()
        newTransaction.date = finalDate
        newTransaction.isAuto = true
        newTransaction.predefCategoryID = typeTransaction == .income ? categoryPredefined0.idUnique : selectedCategory?.idUnique ?? ""
        newTransaction.predefSubcategoryID = typeTransaction == .income ? "" : selectedSubcategory?.idUnique ?? ""
        
        let newAutomation = Automation(context: viewContext)
        newAutomation.id = UUID()
        newAutomation.title = titleTransaction
        newAutomation.date = finalDate
        newAutomation.frenquently = automationFrenquently == .monthly ? 0 : 1
        newAutomation.automationToTransaction = newTransaction
        newAutomation.automationToAccount = mainAccount
        
        newTransaction.transactionToAutomation = newAutomation
        
        do {
            try viewContext.save()
            print("🔥 New Transaction created with Success")
            print("🔥 New Automation created with Success")
            theNewTransaction = newTransaction
            theNewAutomation = newAutomation
            withAnimation { showSuccessfulAutomation.toggle() }
        } catch {
            print("⚠️ Error for : \(error.localizedDescription)")
        }
    }
    
}

// MARK: - Verification
extension AddAutomationViewModel {
    
    func isAutomationInCreation() -> Bool {
        if showSuccessfulAutomation { return false }
        if selectedCategory != nil || selectedSubcategory != nil || !titleTransaction.isEmpty || amountTransaction.convertToDouble() != 0 {
            return true
        }
        return false
    }
    
    func validateAutomation() -> Bool {
        if !titleTransaction.isEmptyWithoutSpace() && amountTransaction.convertToDouble() != 0.0 && selectedCategory != nil {
            return true
        }
        return false
    }
}
