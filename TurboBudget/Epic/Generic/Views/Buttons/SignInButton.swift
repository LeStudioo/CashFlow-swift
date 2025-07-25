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
                Image(config.icon)
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
        var icon: ImageResource
        var title: String
    }
}

// MARK: - Preview
#Preview {
    SignInButton(
        config: .init(
            icon: .appleLogo,
            title: "Sign in with Apple"
        ),
        action: { }
    )
    .padding()
    .background(Color.primary200)
}
