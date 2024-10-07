//
//  ToolbarDismissButtonView.swift
//  CashFlow
//
//  Created by KaayZenn on 27/02/2024.
//

import SwiftUI

struct ToolbarDismissButtonView: ToolbarContent {
    
    // Builder
    var action: () -> Void
    
    // MARK: - body
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: action, label: {
                Text("word_cancel".localized)
                    .font(.regularText16())
                    .foregroundStyle(ThemeManager.theme.color)
            })
        }
    } // End body
} // End struct
