//
//  LoginView.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import SwiftUI
import AuthenticationServices
import NetworkKit

struct LoginView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let signInWithAppleManager: SignInWithAppleManager = .init()
    private let signInWithGoogleManager: SignInWithGoogleManager = .init()
    
    // MARK: -
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Image(.logoWalletCashFlow)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                    .padding(4)
                    .background(Color.background200, in: .rect(cornerRadius: 36, style: .continuous))
                    .padding(64)
                
                VStack(spacing: 8) {
                    Text("CashFlow")
                        .font(.semiBoldH2())
                    
                    Text("login_message".localized)
                        .font(.mediumText16())
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
            
            VStack(spacing: DesignSystem.Spacing.standard) {
                SignInButton(
                    config: .init(
                        icon: .googleLogo,
                        title: "login_google".localized
                    ),
                    action: { signInWithGoogleManager.signIn() }
                )
                
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        if let credential = authResults.credential as? ASAuthorizationAppleIDCredential {
                            if let appleIDToken = credential.identityToken, let idTokenString = String(data: appleIDToken, encoding: .utf8) {
                                Task {
                                    let user = try await NetworkService.sendRequest(
                                        apiBuilder: AuthAPIRequester.apple(body: .init(identityToken: idTokenString)),
                                        responseModel: UserModel.self
                                    )
                                    
                                    if let token = user.token, let refreshToken = user.refreshToken {
                                        TokenManager.shared.setTokenAndRefreshToken(token: token, refreshToken: refreshToken)
                                        UserStore.shared.currentUser = user
                                        AppManager.shared.appState = .success
                                    }
                                }
                            } else {
                                AppManager.shared.appState = .needLogin
                            }
                        } else {
                            AppManager.shared.appState = .needLogin
                        }
                    case .failure(let error):
                        print("Authorisation failed: \(error.localizedDescription)")
                    }
                }
                // black button
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.standard, style: .continuous))
                .frame(height: 48)
            }
        }
        .padding(DesignSystem.Padding.large)
    } // body
} // struct

// MARK: - Preview
#Preview {
    LoginView()
}
