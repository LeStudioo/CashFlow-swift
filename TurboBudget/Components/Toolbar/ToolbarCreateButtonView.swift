//
//  ToolbarCreateButtonView.swift
//  CashFlow
//
//  Created by KaayZenn on 27/02/2024.
//

import SwiftUI

struct ToolbarCreateButtonView: ToolbarContent {
    
    // Builder
    var isActive: Bool
    var action: () -> Void
    
    // MARK: - body
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: action, label: {
                Text("word_create".localized)
                    .font(.boldText16())
                    .foregroundStyle(ThemeManager.theme.color)
            })
            .disabled(!isActive)
            .opacity(isActive ? 1 : 0.5)
        }
    } // End body
} // End struct
