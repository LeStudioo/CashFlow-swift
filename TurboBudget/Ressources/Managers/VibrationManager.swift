//
//  VibrationManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/08/2024.
//

import Foundation
import UIKit

final class VibrationManager {
    
}

extension VibrationManager {
    
    static func vibration() {
        @Preference(\.hapticFeedback) var hapticFeedback
        
        if hapticFeedback {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    
}
