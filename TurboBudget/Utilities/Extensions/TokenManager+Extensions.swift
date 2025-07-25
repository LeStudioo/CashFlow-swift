//
//  TokenManager+Extensions.swift
//  CashFlow
//
//  Created by Theo Sementa on 25/07/2025.
//
// TODO: Edit this bad files

import Foundation
import NetworkKit
import CoreModule
import UserModule

extension TokenManager {

    @MainActor
    func refreshToken() async throws {
        if let refreshTokenInKeychain = KeychainManager.shared.retrieveItemFromKeychain(
            id: KeychainService.refreshToken.rawValue,
            type: String.self
        ), !refreshTokenInKeychain.isEmpty {
            do {
                let user = try await NetworkService.sendRequest(
                    apiBuilder: UserAPIRequester.refreshToken(refreshToken: refreshTokenInKeychain),
                    responseModel: UserModel.self
                )
                
                if let refreshToken = user.refreshToken, let token = user.token {
                    self.token = token
                    KeychainManager.shared.setItemToKeychain(id: KeychainService.refreshToken.rawValue, data: refreshToken)
                    KeychainManager.shared.setItemToKeychain(id: KeychainService.token.rawValue, data: token)
                    
                    UserStore.shared.currentUser = user
                } else {
                    throw NSError(domain: "refreshTokenFailed", code: 401)
//                    throw NetworkError.refreshTokenFailed // TODO: REACTIVE
                }
            }
        } else {
            UserStore.shared.currentUser = nil
            TokenManager.shared.setTokenAndRefreshToken(token: "", refreshToken: "")
            throw NSError(domain: "refreshTokenFailed", code: 401)
//            throw NetworkError.refreshTokenFailed // TODO: REACTIVE
        }
    }
    
}

extension UserStore {
    
    @MainActor
    func loginWithToken() async throws {
        try await TokenManager.shared.refreshToken()
    }
    
}
