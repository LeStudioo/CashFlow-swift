//
//  AccountPreferences.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/04/2025.
//

import Foundation
import Combine
import CoreModule

final class AccountPreferences: ObservableObject {
    static let shared = AccountPreferences()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("PreferencesAccount_mainAccountId", defaultValue: 0)
    var mainAccountId: Int {
        willSet { objectWillChange.send() }
    }
    
}
