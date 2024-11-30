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
    func showSuccessfulTransfer(type: SuccessfulType, transfer: TransactionModel) {
        self.title = Word.Successful.Transfer.title(type: type)
        self.subtitle = Word.Successful.Transfer.description(type: type)
        self.content = AnyView(TransferRow(transfer: transfer, location: .successfulSheet).disabled(true))
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
    
    @MainActor
    func showSuccessfulSubscription(type: SuccessfulType, subscription: SubscriptionModel) {
        self.title = Word.Successful.Subscription.title(type: type)
        self.subtitle = Word.Successful.Subscription.description(type: type)
        self.content = AnyView(SubscriptionRow(subscription: subscription).disabled(true))
            
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
    
    @MainActor
    func showSuccessfulContribution(type: SuccessfulType, contribution: ContributionModel) {
        self.title = Word.Successful.Contribution.title(type: type)
        self.subtitle = Word.Successful.Contribution.description(type: type)
        self.content = AnyView(ContributionRow(contribution: contribution))
        
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
