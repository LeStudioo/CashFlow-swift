//
//  PresentActions.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/01/2025.
//

import Foundation
import SwiftUI

extension NavigationManager {
    
    func presentWhatsNew() {
        presentSheet(.whatsNew)
    }
    
    func presentPaywall() {
        presentSheet(.paywall)
    }
    
    func presentCreateAccount(type: AccountType, account: AccountModel? = nil) {
        presentSheet(.createAccount(type: type, account: account))
    }
    
    func presentCreateSubscription(subscription: SubscriptionModel? = nil, dismissAction: (() -> Void)? = nil) {
        presentSheet(.createSubscription(subscription: subscription), dismissAction)
    }
    
    func presentCreateBudget() {
        presentSheet(.createBudget)
    }
    
    func presentCreateSavingsPlan(savingsPlan: SavingsPlanModel? = nil, dismissAction: (() -> Void)? = nil) {
        presentSheet(.createSavingsPlan(savingsPlan: savingsPlan), dismissAction)
    }
    
    func presentCreateContribution(savingsPlan: SavingsPlanModel, dismissAction: (() -> Void)? = nil) {
        presentSheet(.createContribution(savingsPlan: savingsPlan), dismissAction)
    }
    
    func presentCreateTransaction(transaction: TransactionModel? = nil, dismissAction: (() -> Void)? = nil) {
        presentSheet(.createTransaction(transaction: transaction), dismissAction)
    }
    
    func presentCreateTransfer(receiverAccount: AccountModel? = nil, dismissAction: (() -> Void)? = nil) {
        presentSheet(.createTransfer(receiverAccount: receiverAccount), dismissAction)
    }
    
    func presentCreateCreditCard(dismissAction: (() -> Void)? = nil) {
        presentSheet(.createCreditCard, dismissAction)
    }
    
    func presentCreateTransactionForSavingsAccount(savingsAccount: AccountModel, transaction: TransactionModel? = nil) {
        presentSheet(.createTransactionForSavingsAccount(savingsAccount: savingsAccount, transaction: transaction))
    }
    
    func presentQrCodeScanner(dismissAction: (() -> Void)? = nil) {
        presentSheet(.qrCodeScanner, dismissAction)
    }
    
    func presentSelectCategory(
        category: Binding<CategoryModel?>,
        subcategory: Binding<SubcategoryModel?>,
        dismissAction: (() -> Void)? = nil
    ) {
        presentSheet(.selectCategory(category: category, subcategory: subcategory), dismissAction)
    }
    
}
