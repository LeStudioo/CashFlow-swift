//
//  PreferencesGeneral.swift
//  CoreModule
//
//  Created by Theo Sementa on 25/07/2025.
//


import Foundation
import Combine

public final class PreferencesGeneral: ObservableObject {
    public static let shared = PreferencesGeneral()
        
    public let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("isDataSynced", defaultValue: false) // PreferencesGeneral_isDataSynced
    public var isDataSynced: Bool {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault("PreferencesGeneral_numberOfOpenings", defaultValue: 0) // PreferencesGeneral_numberOfOpenings
    public var numberOfOpenings: Int {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault("PreferencesGeneral_isReviewPopupPresented", defaultValue: false) // PreferencesGeneral_isReviewPopupPresented
    public var isReviewPopupPresented: Bool {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault("alreadyOpen", defaultValue: false) // PreferencesGeneral_isAlreadyOpen
    public var isAlreadyOpen: Bool {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault("hapticFeedback", defaultValue: true) // PreferencesGeneral_hapticFeedback
    public var hapticFeedback: Bool {
        willSet { objectWillChange.send() }
    }

    @UserDefault("PreferencesGeneral_whatsnewv2.0.4", defaultValue: false)
    public var isWhatsNewSeen: Bool {
        willSet { objectWillChange.send() }
    }
    
    // MARK: - Tips
    @UserDefault("PreferencesGeneral_isApplePayEnabled", defaultValue: false)
    public var isApplePayEnabled: Bool {
        willSet { objectWillChange.send() }
    }
}
