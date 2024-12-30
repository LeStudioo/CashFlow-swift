//
//  MenuCreationButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/12/2024.
//

import SwiftUI

struct MenuCreationAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let present: () -> Void
    let isDisabled: Bool
    let onTapAction: (() -> Void)?
    
    init(
        title: String,
        icon: String,
        present: @escaping () -> Void,
        isDisabled: Bool = false,
        onTapAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.present = present
        self.isDisabled = isDisabled
        self.onTapAction = onTapAction
    }
}

struct MenuCreationButton: View {
    let action: MenuCreationAction
    let onPress: () -> Void
    
    var body: some View {
        NavigationButton(present: action.present()) {
            onPress()
            VibrationManager.vibration()
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
    MenuCreationButton(
        action: .init(
            title: "Preview",
            icon: "person.crop.circle",
            present: { }
        ),
        onPress: { }
    )
}
