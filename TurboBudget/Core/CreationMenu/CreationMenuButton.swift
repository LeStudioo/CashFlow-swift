//
//  CreationMenuButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/12/2024.
//

import SwiftUI
import NavigationKit

struct CreationMenuAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let destination: AppDestination
    let isDisabled: Bool
    let onTapAction: (() -> Void)?
    
    init(
        title: String,
        icon: String,
        destination: AppDestination,
        isDisabled: Bool = false,
        onTapAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.destination = destination
        self.isDisabled = isDisabled
        self.onTapAction = onTapAction
    }
}

struct CreationMenuButton: View {
    let action: CreationMenuAction
    let onPress: () -> Void
    
    var body: some View {
        Button {
            onPress()
            AppManager.shared.selectedTab = 0
            AppRouterManager.shared.router(for: .home)?.push(action.destination)
        } label: {
            Label(action.title, systemImage: action.icon)
                .font(.Subtitle.medium)
        }
        .disabled(action.isDisabled)
        .onTapGesture {
            action.onTapAction?()
        }
    }
}

// MARK: - Preview
#Preview {
    CreationMenuButton(
        action: .init(
            title: "Preview",
            icon: "person.crop.circle",
            destination: .transaction(.create)
        ),
        onPress: { }
    )
}
