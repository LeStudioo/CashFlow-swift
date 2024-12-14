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
    @Published var uuids: [UUID] = []
}

extension CreditCardRepository {
 
    @MainActor
    func fetchCreditCards(accountID: Int) async {
        do {
            let uuids = try await NetworkService.shared.sendRequest(
                apiBuilder: CreditCardAPIRequester.fetch(accountID: accountID),
                responseModel: [UUID].self
            )
            self.uuids = uuids
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func createCreditCard(accountID: Int, uuid: UUID) async {
        do {
            let uuid = try await NetworkService.shared.sendRequest(
                apiBuilder: CreditCardAPIRequester.create(accountID: accountID, cardUUID: uuid),
                responseModel: UUID.self
            )
            self.uuids.append(uuid)
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteCreditCard(accountID: Int, cardID: UUID) async {
        do {
            try await NetworkService.shared.sendRequest(
                apiBuilder: CreditCardAPIRequester.delete(accountID: accountID, cardID: cardID)
            )
            self.uuids.removeAll(where: { $0 == cardID })
        } catch { NetworkService.handleError(error: error) }
    }
    
}
