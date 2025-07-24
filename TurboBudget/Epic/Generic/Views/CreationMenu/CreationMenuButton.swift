//
//  CreationMenuButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/12/2024.
//

import SwiftUI
import NavigationKit
import CoreModule

struct CreationMenuAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: ImageResource
    let destination: AppDestination
    let isDisabled: Bool
    let onTapAction: (() -> Void)?
    
    init(
        title: String,
        icon: ImageResource,
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
            Label {
                Text(action.title)
                    .fontWithLineHeight(.Title.medium)
            } icon: {
                Image(action.icon)
                    .renderingMode(.template)
            }
            .foregroundStyle(Color.label)
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
            icon: .iconPerson,
            destination: .transaction(.create)
        ),
        onPress: { }
    )
}
