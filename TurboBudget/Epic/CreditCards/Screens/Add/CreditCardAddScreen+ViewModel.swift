//
//  CreateCreditCardViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/12/2024.
//

import Foundation
import SwiftUI

extension CreditCardAddScreen {
    
    final class ViewModel: ObservableObject {
        
        @Published var cardNumbers: String = ""
        @Published var cvv: String = ""
        @Published var cardHolder: String = ""
        @Published var expirationDate: Date = .now
        @Published var limitByMonth: String = ""
        
        @Published var presentingConfirmationDialog: Bool = false
        
    }
    
}

extension CreditCardAddScreen.ViewModel {
    
    @MainActor
    func createCreditCard(dismiss: DismissAction) async {
        guard let account = AccountStore.shared.selectedAccount, let accountID = account._id else { return }
        let creditCardStore: CreditCardStore = .shared
        
        let randomUUID = UUID()
        let newCreditCard = CreditCardModel(
            uuid: randomUUID,
            holder: cardHolder,
            number: cardNumbers,
            cvc: cvv,
            expirateDate: expirationDate.toISO(),
            limitByMonth: limitByMonth.toDouble() != 0 ? limitByMonth.toDouble() : nil
        )
        
        await creditCardStore.createCreditCard(accountID: accountID, uuid: randomUUID)
        KeychainManager.shared.setItemToKeychain(id: randomUUID.uuidString, data: newCreditCard)
        creditCardStore.creditCards.append(newCreditCard)
        dismiss()
    }
    
}

extension CreditCardAddScreen.ViewModel {
    
    func isCreditCardInCreation() -> Bool {
        if !cardNumbers.isEmpty || !cvv.isEmpty || !cardHolder.isEmpty {
            return true
        }
        return false
    }
    
    func isCreditCardValid() -> Bool {
        if !cardNumbers.isBlank && cvv.count == 3 && !cardHolder.isBlank {
            return true
        }
        return false
    }
    
}
