//
//  CreditCardRepository.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

final class CreditCardRepository: ObservableObject {
    static let shared = CreditCardRepository()
    
    @Published var creditCards: [CreditCardModel] = []
}

extension CreditCardRepository {
 
    @MainActor
    func fetchCreditCards(accountID: Int) async {
        do {
            let creditsCards = try await NetworkService.shared.sendRequest(
                apiBuilder: CreditCardAPIRequester.fetch(accountID: accountID),
                responseModel: [UUID].self
            )
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func createCreditCard(accountID: Int, uuid: UUID) async {
        do {
            let uuid = try await NetworkService.shared.sendRequest(
                apiBuilder: CreditCardAPIRequester.create(accountID: accountID, cardUUID: uuid),
                responseModel: UUID.self
            )
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteCreditCard(cardID: Int) async {
        do {
            try await NetworkService.shared.sendRequest(
                apiBuilder: CreditCardAPIRequester.delete(cardID: cardID)
            )
        } catch { NetworkService.handleError(error: error) }
    }
    
}
