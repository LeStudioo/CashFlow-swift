//
//  File.swift
//  CashFlow
//
//  Created by KaayZenn on 16/10/2023.
//

import Foundation
import AppIntents
import SwiftUI

struct AddTransactionShortcuts: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor = .blue
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddTransactionIntent(),
            phrases: [
                "New transaction in \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource(stringLiteral: "appIntent_createTransaction"),
            systemImageName: "creditcard.and.123"
        )
    }
}
