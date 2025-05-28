//
//  TransferService.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/01/2025.
//

import Foundation
import NetworkKit

struct TransferService {
    
    static func create(
        from senderAccountID: Int,
        to receiverAccountID: Int,
        body: TransferBody
    ) async throws -> TransferResponseWithBalances {
        return try await NetworkService.sendRequest(
            apiBuilder: TransferAPIRequester.transfer(
                senderAccountID: senderAccountID,
                receiverAccountID: receiverAccountID,
                body: body
            ),
            responseModel: TransferResponseWithBalances.self
        )
    }
    
    static func delete(id: Int) async throws -> TransferResponseWithBalances {
        return try await NetworkService.sendRequest(
            apiBuilder: TransferAPIRequester.delete(transferID: id),
            responseModel: TransferResponseWithBalances.self
        )
    }
    
}
