//
//  PreferencesGeneral.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

//import Foundation
//import Combine
//
//final class PreferencesGeneral: ObservableObject {
//    static let shared = PreferencesGeneral()
//        
//    let objectWillChange = PassthroughSubject<Void, Never>()
//    
//    @UserDefault("isDataSynced", defaultValue: false) // PreferencesGeneral_isDataSynced
//    var isDataSynced: Bool {
//        willSet { objectWillChange.send() }
//    }
//    
//    @UserDefault("PreferencesGeneral_numberOfOpenings", defaultValue: 0) // PreferencesGeneral_numberOfOpenings
//    var numberOfOpenings: Int {
//        willSet { objectWillChange.send() }
//    }
//    
//    @UserDefault("PreferencesGeneral_isReviewPopupPresented", defaultValue: false) // PreferencesGeneral_isReviewPopupPresented
//    var isReviewPopupPresented: Bool {
//        willSet { objectWillChange.send() }
//    }
//    
//    @UserDefault("alreadyOpen", defaultValue: false) // PreferencesGeneral_isAlreadyOpen
//    var isAlreadyOpen: Bool {
//        willSet { objectWillChange.send() }
//    }
//    
//    @UserDefault("hapticFeedback", defaultValue: true) // PreferencesGeneral_hapticFeedback
//    var hapticFeedback: Bool {
//        willSet { objectWillChange.send() }
//    }
//
//    @UserDefault("PreferencesGeneral_whatsnewv2.0.4", defaultValue: false)
//    var isWhatsNewSeen: Bool {
//        willSet { objectWillChange.send() }
//    }
//    
//    // MARK: - Tips
//    @UserDefault("PreferencesGeneral_isApplePayEnabled", defaultValue: false)
//    var isApplePayEnabled: Bool {
//        willSet { objectWillChange.send() }
//    }
//}
