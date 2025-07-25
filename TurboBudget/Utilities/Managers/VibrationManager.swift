//
//  VibrationManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/08/2024.
//

import Foundation
import UIKit
import CoreModule
import PreferencesModule

final class VibrationManager { }

extension VibrationManager {
    
    static func vibration() {
        if PreferencesGeneral.shared.hapticFeedback {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    
}
