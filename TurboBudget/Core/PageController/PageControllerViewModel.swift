//
//  PageControllerViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 27/10/2023.
//

import Foundation
import LocalAuthentication

class PageControllerViewModel: ObservableObject {
    static let shared = PageControllerViewModel()
        
    @Published var showOnboarding: Bool = false
    @Published var isUnlocked: Bool = false
    @Published var launchScreenEnd: Bool = false
}

extension PageControllerViewModel {
    
    @MainActor
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "alert_request_biometric".localized
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { isAllowed, _ in
                self.isUnlocked = isAllowed
                UserDefaults.standard.set(isAllowed, forKey: "appIsOpen")
            }
        } else {
            // no biometrics
        }
    }
}
