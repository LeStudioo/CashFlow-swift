//
//  KeychainManager.swift
//  LifeFlow
//
//  Created by Theo Sementa on 12/03/2024.
//

import Foundation
import Security

enum KeychainService: String {
    case refreshToken
}

final class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    func setItemToKeychain<T: Codable>(id: String, data: T) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: id,
                kSecAttrSynchronizable: kSecAttrSynchronizableAny,
                kSecValueData: encodedData
            ]
            
            // Essayer d'abord de supprimer l'item existant
            SecItemDelete(query as CFDictionary)
            
            // Puis ajouter le nouvel item
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status != errSecSuccess {
                print("Erreur lors de l'enregistrement dans le Keychain: \(status)")
            }
        } catch {
            print("Erreur d'encodage: \(error)")
        }
    }
    
    func retrieveItemFromKeychain<T: Decodable>(id: String, type: T.Type) -> T? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: id,
            kSecAttrSynchronizable: kSecAttrSynchronizableAny,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data else {
            return nil
        }
        
        do {
            let item = try JSONDecoder().decode(T.self, from: data)
            return item
        } catch {
            print("Erreur de décodage: \(error)")
            return nil
        }
    }
}
