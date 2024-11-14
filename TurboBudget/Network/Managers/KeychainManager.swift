//
//  KeychainManager.swift
//  LifeFlow
//
//  Created by Theo Sementa on 12/03/2024.
//

import Foundation
import Security
import LocalAuthentication

struct Credentials {
    var email: String
    var password: String
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

enum KeychainServiceManager: String {
    case refreshToken = "refreshToken"
}

class KeychainManager {
    static let shared = KeychainManager()
}

extension KeychainManager {
    
    func retrieveItem(service: KeychainServiceManager) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: service.rawValue,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary
                
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        if let result = result as? NSDictionary {
            if let itemData = result[kSecValueData] as? Data {
                let item = String(data: itemData, encoding: .utf8)!
                return item
            }
        }
        
        return nil
    }
    
    func setItemToKeychain(newValue: String, service: KeychainServiceManager) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: service.rawValue,
            kSecValueData: newValue.data(using: .utf8)!,
        ] as CFDictionary
        
        var status = SecItemAdd(query, nil)
                
        if status == errSecDuplicateItem {
            // Item already exist, thus update it.
            let updateQuery = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount as String: service.rawValue
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: newValue.data(using: .utf8)!] as CFDictionary
            status = SecItemUpdate(updateQuery, attributesToUpdate)
        }
    }
}
