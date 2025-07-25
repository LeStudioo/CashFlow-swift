//
//  TokenManager.swift
//  HappyEat_iOS
//
//  Created by Theo Sementa on 12/03/2024.
//

import Foundation
import NetworkKit

public class TokenManager: ObservableObject {
    public static let shared = TokenManager()
    
    @Published public var token: String = ""
}

public extension TokenManager {
    
    func setToken(token: String) {
        self.token = token
    }
    
    func setTokenAndRefreshToken(token: String, refreshToken: String) {
        self.token = token
        KeychainManager.shared.setItemToKeychain(id: KeychainService.refreshToken.rawValue, data: refreshToken)
    }
    
}
