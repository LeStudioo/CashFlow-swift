//
//  LoginView.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import SwiftUI

struct LoginView: View {
    
    private let signInWithAppleManager: SignInWithAppleManager = .init()
    private let signInWithGoogleManager: SignInWithGoogleManager = .init()
    
    // MARK: -
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Image(.logoCashFlow)
                    .resizable()
                    .scaledToFit()
                
                VStack(spacing: 8) {
                    Text("login_connection".localized)
                        .font(.system(size: 28, weight: .semibold))
                    
                    Text("login_message".localized)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                SignInButton(
                    config: .init(
                        icon: .googleLogo,
                        title: "login_google".localized
                    ),
                    action: { signInWithGoogleManager.signIn() }
                )
                
                SignInButton(
                    config: .init(
                        icon: .appleLogo,
                        title: "login_apple".localized
                    ),
                    action: { signInWithAppleManager.performSignIn() }
                )
            }
        }
        .padding(.horizontal)
    } // body
} // struct

// MARK: - Preview
#Preview {
    LoginView()
}
