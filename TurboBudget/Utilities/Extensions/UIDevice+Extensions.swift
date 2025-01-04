//
//  UIDevice+Extensions.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/12/2024.
//

import Foundation
import UIKit
import LocalAuthentication

extension UIDevice {
    
    static var biometry: BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:     return .none
            case .touchID:  return .touch
            case .faceID:   return .face
            case .opticID:  break
            default:
                print("⚠️ Error for check biometric")
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
        
        return .none
    }
    
    static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
}
