//
//  ToolbarCreateButtonView.swift
//  CashFlow
//
//  Created by KaayZenn on 27/02/2024.
//

import SwiftUI

enum ValidationButtonType {
    case creation
    case edition
}

struct ToolbarValidationButtonView: ToolbarContent {
    
    // Builder
    var type: ValidationButtonType = .creation
    var isActive: Bool
    var action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - body
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: action, label: {
                Text(type == .creation ? Word.Classic.create : Word.Classic.edit)
                    .font(.boldText16())
                    .foregroundStyle(themeManager.theme.color)
            })
            .disabled(!isActive)
            .opacity(isActive ? 1 : 0.5)
        }
    } // End body
} // End struct
