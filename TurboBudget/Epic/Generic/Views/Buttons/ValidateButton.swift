//
//  ValidateButton.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct ValidateButton: View {

    var action: () -> Void
    var validate: Bool
    
    @EnvironmentObject private var themeManager: ThemeManager

    // MARK: -
    var body: some View {
        Button(action: action, label: {
            ZStack {
                Capsule()
                    .foregroundStyle(themeManager.theme.color)
                    .frame(height: UIDevice.isLittleIphone ? 50 : 60)
                    .shadow(color: validate ? themeManager.theme.color : Color.clear, radius: validate ? 8 : 0)
                HStack {
                    Spacer()
                    Text("word_validate".localized)
                        .font(.semiBoldCustom(size: 20))
                        .foregroundStyle(.primary0)
                    Spacer()
                }
            }
        })
        .disabled(!validate)
        .opacity(validate ? 1 : 0.4)
        .padding(.horizontal, 8)
    } // body
} // struct

// MARK: - Preview
#Preview {
    ValidateButton(action: { }, validate: true)
}
