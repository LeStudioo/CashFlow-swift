//
//  SuccessfullModalManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/08/2024.
//

import SwiftUI

enum SuccessfulType: String {
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
        self.title = Word.Successful.Transaction.title(type: type)
        self.subtitle = Word.Successful.Transaction.description(type: type)
        self.content = AnyView(TransactionRow(transaction: transaction).disabled(true))
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
 
    @MainActor
    func showSuccessfulSavingsPlan(type: SuccessfulType, savingsPlan: SavingsPlanModel) {
        self.title = Word.Successful.SavingsPlan.title(type: type)
        self.subtitle = Word.Successful.SavingsPlan.description(type: type)
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
