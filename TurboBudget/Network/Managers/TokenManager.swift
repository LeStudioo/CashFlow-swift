//
//  TokenManager.swift
//  HappyEat_iOS
//
//  Created by Theo Sementa on 12/03/2024.
//

import Foundation
import NetworkKit

class TokenManager: ObservableObject {
    static let shared = TokenManager()
    
    @Published var token: String = ""
}

extension TokenManager {
    
    func setToken(token: String) {
        self.token = token
    }
    
    func setTokenAndRefreshToken(token: String, refreshToken: String) {
        self.token = token
        KeychainManager.shared.setItemToKeychain(id: KeychainService.refreshToken.rawValue, data: refreshToken)
    }
    
    @MainActor
    func refreshToken() async throws {
        if let refreshTokenInKeychain = KeychainManager.shared.retrieveItemFromKeychain(id: KeychainService.refreshToken.rawValue, type: String.self), !refreshTokenInKeychain.isEmpty {
            do {
                let user = try await NetworkService.sendRequest(
                    apiBuilder: UserAPIRequester.refreshToken(refreshToken: refreshTokenInKeychain),
                    responseModel: UserModel.self
                )
                
                if let refreshToken = user.refreshToken, let token = user.token {
                    self.token = token
                    KeychainManager.shared.setItemToKeychain(id: KeychainService.refreshToken.rawValue, data: refreshToken)
                    
                    UserStore.shared.currentUser = user
                } else {
                    throw NetworkError.refreshTokenFailed
                }
            }
        } else {
            UserStore.shared.currentUser = nil
            TokenManager.shared.setTokenAndRefreshToken(token: "", refreshToken: "")
            throw NetworkError.refreshTokenFailed
        }
    }
    
}
