//
//  TransferService.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/01/2025.
//

import Foundation

struct TransferService {
    
    static func create(
        from senderAccountID: Int,
        to receiverAccountID: Int,
        body: TransferBody
    ) async throws -> TransferResponseWithBalances {
        return try await NetworkService.shared.sendRequest(
            apiBuilder: TransferAPIRequester.transfer(
                senderAccountID: senderAccountID,
                receiverAccountID: receiverAccountID,
                body: body
            ),
            responseModel: TransferResponseWithBalances.self
        )
    }
    
    static func delete(id: Int) async throws -> TransferResponseWithBalances {
        return try await NetworkService.shared.sendRequest(
            apiBuilder: TransferAPIRequester.delete(transferID: id),
            responseModel: TransferResponseWithBalances.self
        )
    }
    
}
