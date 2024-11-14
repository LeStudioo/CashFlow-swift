//
//  TokenManager.swift
//  HappyEat_iOS
//
//  Created by Theo Sementa on 12/03/2024.
//

import Foundation

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
        KeychainManager.shared.setItemToKeychain(newValue: refreshToken, service: .refreshToken)
    }
    
    @MainActor
    func refreshToken() async throws {
        if let refreshTokenInKeychain = KeychainManager.shared.retrieveItem(service: .refreshToken) {
            do {
                let user = try await NetworkService.shared.sendRequest(
                    apiBuilder: UserAPIRequester.refreshToken(refreshToken: refreshTokenInKeychain),
                    responseModel: UserModel.self
                )
                
                if let refreshToken = user.refreshToken, let token = user.token {
                    self.token = token
                    KeychainManager.shared.setItemToKeychain(
                        newValue: refreshToken,
                        service: .refreshToken
                    )
                    
                    UserRepository.shared.currentUser = user
                } else {
                    throw NetworkError.refreshTokenFailed
                }
            }
        } else {
            UserRepository.shared.currentUser = nil
            TokenManager.shared.setTokenAndRefreshToken(token: "", refreshToken: "")
            throw NetworkError.refreshTokenFailed
        }
    }
    
}
