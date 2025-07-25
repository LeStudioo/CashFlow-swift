//
//  SwiftUIView.swift
//  OnboardingModule
//
//  Created by Theo Sementa on 24/07/2025.
//

import SwiftUI
import DesignSystemModule
import AuthenticationServices
import UserModule
import NetworkKit
import CoreModule

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
        || item.title == "onboarding_welcome_back_title".localized
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
                    .auraEffect(radius: 200, padding: 200)
                
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
                VStack(spacing: Spacing.small) {
                    VStack(spacing: Spacing.medium) {
                        SignInButton(
                            config: .init(
                                icon: .Brand.google,
                                title: "login_google".localized
                            ),
                            action: { signInWithGoogleManager.signIn() }
                        )
                        
                        SignInButton(
                            config: .init(
                                icon: .Brand.apple,
                                title: "login_apple".localized
                            ),
                            action: { signInWithAppleManager.performSignIn() }
                        )
                    }
                    Text("onboarding_page_three_extra_label".localized)
                        .fontWithLineHeight(.Body.small)
                        .foregroundStyle(Color.Background.bg600)
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
