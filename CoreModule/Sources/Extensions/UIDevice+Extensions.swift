//
//  File.swift
//  CoreModule
//
//  Created by Theo Sementa on 20/07/2025.
//

import Foundation
import UIKit
import LocalAuthentication

public extension UIDevice {
    
    static var biometry: BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch authContext.biometryType {
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
    
    static let isIpad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    static let isLittleIphone = UIScreen.main.bounds.width < 380 ? true : false
    
}
