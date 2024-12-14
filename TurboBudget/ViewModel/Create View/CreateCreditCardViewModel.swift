//
//  CreateCreditCardViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/12/2024.
//

import Foundation
import SwiftUI

final class CreateCreditCardViewModel: ObservableObject {
    
    @Published var cardNumbers: String = ""
    @Published var cvv: String = ""
    @Published var cardHolder: String = ""
    @Published var expirationDate: Date = .now
    @Published var limitByMonth: String = ""
    
    @Published var presentingConfirmationDialog: Bool = false
    
}

extension CreateCreditCardViewModel {
    
    func createCreditCard(dismiss: DismissAction) {
        guard let account = AccountRepository.shared.selectedAccount, let accountID = account.id else { return }
        let creditCardRepository: CreditCardRepository = .shared
        
        let randomUUID = UUID()
        let newCreditCard = CreditCardModel(
            uuid: randomUUID,
            holder: cardHolder,
            number: cardNumbers,
            cvc: cvv,
            expirateDate: expirationDate.toISO(),
            limitByMonth: limitByMonth.toDouble() != 0 ? limitByMonth.toDouble() : nil
        )
        
        Task {
            await creditCardRepository.createCreditCard(accountID: accountID, uuid: randomUUID)
            KeychainManager.shared.setItemToKeychain(id: randomUUID.uuidString, data: newCreditCard)
            creditCardRepository.creditCards.append(newCreditCard)
            await dismiss()
        }
    }
    
}

extension CreateCreditCardViewModel {
    
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
