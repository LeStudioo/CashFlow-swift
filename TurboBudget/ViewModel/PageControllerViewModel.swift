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
        
    @Published var showAlertAccount: Bool = false
    @Published var showOnboarding: Bool = false
    @Published var isUnlocked: Bool = false
    @Published var launchScreenEnd: Bool = false
    @Published var showAlertPaywall: Bool = false
    @Published var showPaywall: Bool = false
    @Published var showUpdateView: Bool = false
}

extension PageControllerViewModel {
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "alert_request_biometric".localized
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    DispatchQueue.main.async {
                        self.isUnlocked = true
                    }
                    UserDefaults.standard.set(true, forKey: "appIsOpen")
                } else {
                    DispatchQueue.main.async {
                        self.isUnlocked = false
                    }
                    UserDefaults.standard.set(false, forKey: "appIsOpen")
                }
            }
        } else {
            // no biometrics
        }
    }
}
