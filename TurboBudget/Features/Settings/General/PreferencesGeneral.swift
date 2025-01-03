//
//  PreferencesGeneral.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

import Foundation

final class PreferencesGeneral: ObservableObject {
    static let shared = PreferencesGeneral()
        
    @CustomUserDefault("isDataSynced", defaultValue: false) // PreferencesGeneral_isDataSynced
    var isDataSynced: Bool
    
    @CustomUserDefault("PreferencesGeneral_numberOfOpenings", defaultValue: 0) // PreferencesGeneral_numberOfOpenings
    var numberOfOpenings: Int
    
    @CustomUserDefault("PreferencesGeneral_isReviewPopupPresented", defaultValue: false) // PreferencesGeneral_isReviewPopupPresented
    var isReviewPopupPresented: Bool
    
    @CustomUserDefault("alreadyOpen", defaultValue: false) // PreferencesGeneral_isAlreadyOpen
    var isAlreadyOpen: Bool
    
    @CustomUserDefault("hapticFeedback", defaultValue: true) // PreferencesGeneral_hapticFeedback
    var hapticFeedback: Bool

    @CustomUserDefault("PreferencesGeneral_whatsnewv2.0.2", defaultValue: false)
    var isWhatsNewSeen: Bool
    
    // MARK: - Tips
    @CustomUserDefault("PreferencesGeneral_isApplePayEnabled", defaultValue: false)
    var isApplePayEnabled: Bool
}
