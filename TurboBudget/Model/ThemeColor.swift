//
//  ThemeColor.swift
//  CashFlow
//
//  Created by KaayZenn on 17/07/2023.
//
// Localizations 01/10/2023

import Foundation
import SwiftUI

struct ThemeColor: Identifiable {
    var id: UUID
    var idUnique: String
    var name: String
    var color: Color
}

let themes: [ThemeColor] = [
    ThemeColor(id: UUID(), idUnique: "111", name: NSLocalizedString("theme_green", comment: ""), color: Color.primary500),
    ThemeColor(id: UUID(), idUnique: "222", name: NSLocalizedString("theme_blue", comment: ""), color: Color.blue),
    ThemeColor(id: UUID(), idUnique: "333", name: NSLocalizedString("theme_purple", comment: ""), color: Color.purple),
    ThemeColor(id: UUID(), idUnique: "444", name: NSLocalizedString("theme_red", comment: ""), color: Color.red),
]
