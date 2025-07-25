//
//  SwiftUIView.swift
//  OnboardingModule
//
//  Created by Theo Sementa on 25/07/2025.
//

import SwiftUI
import DesignSystemModule
import AuthenticationServices

public struct LoginBackScreen: View {
    
    public init() { }
    
    // MARK: - View
    public var body: some View {
        GenericOnboardingScreen(
            item: .init(
                image: .Onboarding.illustrationThree,
                title: "onboarding_welcome_back_title".localized,
                description: "onboarding_welcome_back_description".localized,
                action: { }
            )
        )
    }
}

// MARK: - Preview
#Preview {
    LoginBackScreen()
}
