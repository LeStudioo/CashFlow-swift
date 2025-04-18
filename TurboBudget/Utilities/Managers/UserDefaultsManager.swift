//
//  UserDefaultsManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    func set<T: Codable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }
    
    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = defaults.data(forKey: key),
           let value = try? JSONDecoder().decode(T.self, from: data) {
            return value
        }
        return nil
    }
    
}
