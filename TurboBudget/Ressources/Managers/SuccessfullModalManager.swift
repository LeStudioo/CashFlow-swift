//
//  SuccessfullModalManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/08/2024.
//

import SwiftUI

enum SuccessfulType {
    case new
    case update
}

final class SuccessfullModalManager: ObservableObject {
    static let shared = SuccessfullModalManager()
    
    @Published var isPresenting: Bool = false
    
    @Published var title: String = ""
    @Published var subtitle: String = ""
    @Published var content: any View = EmptyView()
    
}

extension SuccessfullModalManager {
    
    @MainActor
    func showSuccessfulTransaction(type: SuccessfulType, transaction: TransactionModel) {
        self.title = Word.Successful.transactionTitle(type: type)
        self.subtitle = Word.Successful.transactionDesc(type: type)
        self.content = AnyView(TransactionRow(transaction: transaction).disabled(true))
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
 
    @MainActor
    func showSuccessfullSavingsPlan(savingsPlan: SavingsPlanModel) {
        self.title = "savingsplan_successful".localized
        self.subtitle = "savingsplan_successful_desc".localized
        self.content = AnyView(SavingsPlanRow(savingsPlan: savingsPlan))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
    
}

extension SuccessfullModalManager {
    
    func resetData() {
        self.title = ""
        self.subtitle = ""
        self.content = EmptyView()
    }
    
}
