//
//  SwiftUIView.swift
//  OnboardingModule
//
//  Created by Theo Sementa on 24/07/2025.
//

import SwiftUI

public struct OnboardingScreen: View {
    
    @State private var currentPage: Int = 0
    
    var items: [OnboardingItem] {
        return [
            .init(
                image: .Onboarding.illustrationOne,
                title: "onboarding_page_one_title".localized,
                description: "onboarding_page_one_description".localized,
                action: { currentPage = 1 }
            ),
            .init(
                image: .Onboarding.illustrationTwo,
                title: "onboarding_page_two_title".localized,
                description: "onboarding_page_two_description".localized,
                action: { currentPage = 2 }
            ),
            .init(
                image: .Onboarding.illustrationThree,
                title: "onboarding_page_three_title".localized,
                description: "onboarding_page_three_description".localized,
                action: { }
            )
        ]
    }
    
    public init() { }
    
    // MARK: - View
    public var body: some View {
        TabView(selection: $currentPage) {
            ForEach(items.indices) { index in
                GenericOnboardingScreen(item: items[index])
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.smooth, value: currentPage)
    }
}

// MARK: - Preview
#Preview {
    OnboardingScreen()
}
