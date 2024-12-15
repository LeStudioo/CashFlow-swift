//
//  CreateButton.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct CreateButton: View {

    // Builder
    var type: ValidationButtonType = .creation
    var isActive: Bool
    var action: () async -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager

    // MARK: -
    var body: some View {
        Button(action: {
            Task { await action() }
        }, label: {
            Text(type == .creation ? Word.Classic.create : Word.Classic.edit)
                .font(.semiBoldCustom(size: 20))
                .foregroundStyle(.primary0)
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(themeManager.theme.color)
                }
        })
        .disabled(!isActive)
        .opacity(isActive ? 1 : 0.4)
    } // body
} // struct

// MARK: - Preview
#Preview {
    CreateButton(type: .creation, isActive: true, action: {})
}
