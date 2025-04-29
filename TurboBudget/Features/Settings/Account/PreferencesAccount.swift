//
//  PreferencesAccount.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/04/2025.
//

import Foundation
import Combine

final class PreferencesAccount: ObservableObject {
    static let shared = PreferencesAccount()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("PreferencesAccount_mainAccountId", defaultValue: 0)
    var mainAccountId: Int {
        willSet { objectWillChange.send() }
    }
    
}
