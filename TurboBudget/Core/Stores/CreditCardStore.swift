//
//  CreditCardStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

final class CreditCardStore: ObservableObject {
    static let shared = CreditCardStore()
    
    @Published var creditCards: [CreditCardModel] = []
    @Published var uuids: [UUID] = []
}

extension CreditCardStore {
 
    @MainActor
    func fetchCreditCards(accountID: Int) async {
        do {
            let uuids = try await NetworkService.shared.sendRequest(
                apiBuilder: CreditCardAPIRequester.fetch(accountID: accountID),
                responseModel: [UUID].self
            )
            self.uuids = uuids
            for uuid in uuids {
                if let creditCard = KeychainManager.shared.retrieveItemFromKeychain(id: uuid.uuidString, type: CreditCardModel.self) {
                    self.creditCards.append(creditCard)
                }
            }
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
            self.creditCards.removeAll(where: { $0.uuid == cardID })
            KeychainManager.shared.deleteItemFromKeychain(id: cardID.uuidString)
        } catch { NetworkService.handleError(error: error) }
    }
    
}

extension CreditCardStore {
 
    func reset() {
        self.creditCards.removeAll()
        self.uuids.removeAll()
    }
    
}

