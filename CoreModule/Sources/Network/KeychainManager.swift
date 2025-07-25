//
//  KeychainManager.swift
//  LifeFlow
//
//  Created by Theo Sementa on 12/03/2024.
//

import Foundation
import Security

public enum KeychainService: String {
    case refreshToken
    case token
}

public final class KeychainManager {
    public static let shared = KeychainManager()
    private init() {}
    
    public func setItemToKeychain<T: Codable>(id: String, data: T) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: id,
                kSecAttrSynchronizable: false,
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
    
    public func retrieveItemFromKeychain<T: Decodable>(id: String, type: T.Type) -> T? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: id,
            kSecAttrSynchronizable: false,
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
    
    public func deleteItemFromKeychain(id: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: id,
            kSecAttrSynchronizable: false
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Erreur lors de la suppression de l'item du Keychain: \(status)")
        }
    }
}
