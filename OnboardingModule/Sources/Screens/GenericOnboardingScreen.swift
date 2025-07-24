//
//  SwiftUIView.swift
//  OnboardingModule
//
//  Created by Theo Sementa on 24/07/2025.
//

import SwiftUI
import DesignSystemModule
import _AuthenticationServices_SwiftUI

struct GenericOnboardingScreen: View {
    
    // MARK: Dependencies
    let item: OnboardingItem
    
    // MARK: Environments
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: Constants
    private let signInWithAppleManager: SignInWithAppleManager = .init()
    private let signInWithGoogleManager: SignInWithGoogleManager = .init()
    
    // MARK: Computed variables
    var isLastPage: Bool {
        return item.title == "onboarding_page_three_title".localized
    }
    
    // MARK: - View
    var body: some View {
        VStack {
            HStack(spacing: Spacing.small) {
                Image.logoCashFlow
                    .resizable()
                    .frame(width: 28, height: 28)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small, style: .continuous))
                
                Text("CashFlow")
                    .fontWithLineHeight(.Title.medium)
                    .foregroundStyle(Color.text)
            }
            
            VStack(spacing: 32) {
                item.image
                    .resizable()
                    .frame(width: 240, height: 240)
                    .auraEffect(padding: 80)
                
                VStack(spacing: Spacing.small) {
                    Text(item.title)
                        .fontWithLineHeight(.Title.large)
                        .multilineTextAlignment(.center)
                        
                    Text(item.description)
                        .fontWithLineHeight(.Body.medium)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxHeight: .infinity)
            
            if isLastPage {
                VStack(spacing: Spacing.standard) {
                    SignInButton(
                        config: .init(
                            icon: .Brand.google,
                            title: "login_google".localized
                        ),
                        action: { signInWithGoogleManager.signIn() }
                    )
                    
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authResults):
//                            if let credential = authResults.credential as? ASAuthorizationAppleIDCredential {
//                                if let appleIDToken = credential.identityToken, let idTokenString = String(data: appleIDToken, encoding: .utf8) {
//                                    Task {
//                                        let user = try await NetworkService.sendRequest(
//                                            apiBuilder: AuthAPIRequester.apple(body: .init(identityToken: idTokenString)),
//                                            responseModel: UserModel.self
//                                        )
//
//                                        if let token = user.token, let refreshToken = user.refreshToken {
//                                            TokenManager.shared.setTokenAndRefreshToken(token: token, refreshToken: refreshToken)
//                                            UserStore.shared.currentUser = user
//                                            AppManager.shared.appState = .success
//                                        }
//                                    }
//                                } else {
//                                    AppManager.shared.appState = .needLogin
//                                }
//                            } else {
//                                AppManager.shared.appState = .needLogin
//                            }
                            break
                        case .failure(let error):
                            print("Authorisation failed: \(error.localizedDescription)")
                        }
                    }
                    // black button
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.standard, style: .continuous))
                    .frame(height: 48)
                }
            } else {
                ActionButtonView(title: "onboarding_button_next".localized) { item.action() }
            }
        }
        .padding(Padding.large)
    }
}

// MARK: - Preview
#Preview {
    GenericOnboardingScreen(item: .preview)
        .preferredColorScheme(.dark)
}
