//
//  ThemeManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/10/2024.
//

import SwiftUI

enum ThemeColor: String, CaseIterable {
    case green, blue, purple, red
    
    var color: Color {
        switch self {
        case .green: return Color.primary500
        case .blue: return .blue
        case .purple: return .purple
        case .red: return .red
        }
    }
    
    var name: String {
        switch self {
        case .green: return "theme_green".localized
        case .blue: return "theme_blue".localized
        case .purple: return "theme_purple".localized
        case .red: return "theme_red".localized
        }
    }
    
    var nameNotLocalized: String {
        switch self {
        case .green: return "Green"
        case .blue: return "Blue"
        case .purple: return "Purple"
        case .red: return "Red"
        }
    }
}

final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @AppStorage("theme") var theme: ThemeColor = .green
    
}
