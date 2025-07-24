//
//  SignInButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import SwiftUI
import DesignSystemModule

struct SignInButton: View {
    
    // builder
    var config: Configuration
    var action: () -> Void
    
    // MARK: -
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                config.icon
                Text(config.title)
                    .font(.semiBoldText18())
                    .foregroundStyle(Color.textReversed)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: CornerRadius.standard, style: .continuous)
                    .fill(Color.text)
            }
        }
    } // body
} // struct

// MARK: - Configuration
extension SignInButton {
    struct Configuration {
        var icon: Image
        var title: String
    }
}

// MARK: - Preview
#Preview {
    SignInButton(
        config: .init(
            icon: .Brand.apple,
            title: "Sign in with Apple"
        ),
        action: { }
    )
    .padding()
    .background(Color.green)
}
