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
    let successfullModalManager: SuccessfullModalManager = .shared
    
    @Published var selectedCategory: PredefinedCategory? = nil
    @Published var selectedSubcategory: PredefinedSubcategory? = nil
    @Published var titleTransaction: String = ""
    @Published var amountTransaction: String = ""
    @Published var dayAutomation: Int = 1
    @Published var dateAutomation: Date = .now
    @Published var typeTransaction: ExpenseOrIncome = .expense
    @Published var automationFrenquently: AutomationFrequently = .monthly
    
    @Published var allowNotification: Bool = false
    @Published var addNotification: Bool = false
    
    @Published var theNewTransaction: Transaction? = nil
    @Published var theNewAutomation: Automation? = nil
    @Published var presentingConfirmationDialog: Bool = false

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
        newTransaction.predefCategoryID = typeTransaction == .income ? PredefinedCategory.PREDEFCAT0.id : selectedCategory?.id ?? ""
        newTransaction.predefSubcategoryID = typeTransaction == .income ? "" : selectedSubcategory?.id ?? ""
        
        let newAutomation = Automation(context: viewContext)
        newAutomation.id = UUID()
        newAutomation.title = titleTransaction
        newAutomation.date = finalDate
        newAutomation.frenquently = automationFrenquently == .monthly ? 0 : 1
        newAutomation.automationToTransaction = newTransaction
        newAutomation.automationToAccount = AccountRepository.shared.mainAccount
        newTransaction.transactionToAutomation = newAutomation
        
        do {
            try viewContext.save()
            theNewTransaction = newTransaction
            theNewAutomation = newAutomation
            AutomationRepository.shared.automations.append(newAutomation)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.successfullModalManager.isPresenting = true
            }
            successfullModalManager.title = "automation_successful".localized
            successfullModalManager.subtitle = "automation_successful_desc".localized
            successfullModalManager.content = AnyView(
                VStack {
                    CellTransactionWithoutAction(transaction: newTransaction)
                    
                    HStack {
                        Text("automation_successful_date".localized)
                            .font(Font.mediumSmall())
                            .foregroundStyle(.secondary400)
                        Spacer()
                        Text(newAutomation.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.semiBoldSmall())
                            .foregroundStyle(Color(uiColor: .label))
                    }
                    .padding(.horizontal, 8)
                }
            )
        } catch {
            print("⚠️ Error for : \(error.localizedDescription)")
        }
    }
    
}

// MARK: - Verification
extension AddAutomationViewModel {
    
    func isAutomationInCreation() -> Bool {
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
