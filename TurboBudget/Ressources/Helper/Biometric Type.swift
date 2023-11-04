//
//  Biometric Type.swift
//  CashFlow
//
//  Created by Théo Sementa on 05/07/2023.
//

import Foundation
import LocalAuthentication

func biometricType() -> BiometricType {
    let authContext = LAContext()
    if #available(iOS 11, *) {
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch(authContext.biometryType) {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        case .opticID:
            break
        default:
            print("⚠️ Error for check biometric")
        }
    } else {
        return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
    }
    
    return .none
}

enum BiometricType {
    case none
    case touch
    case face
}
