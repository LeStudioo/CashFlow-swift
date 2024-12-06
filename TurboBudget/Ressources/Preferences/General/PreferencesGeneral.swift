//
//  PreferencesGeneral.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

import Foundation
import Combine

final class PreferencesGeneral: ObservableObject {
    static let shared = PreferencesGeneral()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @CustomUserDefault("isDataSynced", defaultValue: false) // PreferencesGeneral_isDataSynced
    var isDataSynced: Bool {
        willSet { objectWillChange.send() }
    }
    
    @CustomUserDefault("isSecurityPlusEnabled", defaultValue: 0) // PreferencesGeneral_numberOfOpenings
    var numberOfOpenings: Int {
        willSet { objectWillChange.send() }
    }
    
    @CustomUserDefault("alreadyOpen", defaultValue: false) // PreferencesGeneral_isAlreadyOpen
    var isAlreadyOpen: Bool {
        willSet { objectWillChange.send() }
    }
    
    @CustomUserDefault("hapticFeedback", defaultValue: true) // PreferencesGeneral_hapticFeedback
    var hapticFeedback: Bool {
        willSet { objectWillChange.send() }
    }

    @CustomUserDefault("whatsnewv2.0", defaultValue: false)
    var isWhatsNewSeen: Bool {
        willSet { objectWillChange.send() }
    }
}
