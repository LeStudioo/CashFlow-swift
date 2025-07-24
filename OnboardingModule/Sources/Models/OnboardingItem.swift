//
//  File.swift
//  OnboardingModule
//
//  Created by Theo Sementa on 24/07/2025.
//

import Foundation
import SwiftUICore

struct OnboardingItem: Identifiable {
    let id: UUID = UUID()
    let image: Image
    let title: String
    let description: String
    let action: () -> Void
    
    init(image: Image, title: String, description: String, action: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.description = description
        self.action = action
    }
}

extension OnboardingItem {
    
    @MainActor
    static let preview: OnboardingItem = .init(
        image: Image.Onboarding.illustrationOne,
        title: "Gérez vos finances simplement.",
        description: "Visualisez vos dépenses, fixez des objectifs et reprenez le contrôle de votre argent.",
        action: { }
    )
    
}
    
