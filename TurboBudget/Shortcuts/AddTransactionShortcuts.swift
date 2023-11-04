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
//                "Hello \(.applicationName)"
            ]
        )
    }
}
//AppShortcut(
//            intent: AddTransactionIntent(),
//            phrases: [
//                "shortcuts_name_one",
//                "\(.applicationName)"
//            ]
//        )

//        AppShortcut(
//            intent: AddTransactionIntent(),
//            phrases: [
//                AppShortcutPhrase(stringLiteral: NSLocalizedString("shortcuts_name_one", comment: "")),
//                "shortcuts_name_one",
//                "Hello \(AppShortcutPhraseToken.applicationName)"
//            ]
//        )

//        AppShortcut(
//            intent: AddTransactionIntent(),
//            phrases: [
//                "shortcuts_name_one",
//                "\(.applicationName)",
//            ],
//            shortTitle: LocalizedStringResource(stringLiteral: "shortcuts_name_one"),
//            systemImageName: "plus"
//        )
