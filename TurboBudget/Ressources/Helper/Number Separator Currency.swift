//
//  Number Separator Currency.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import Foundation
import SwiftUI

// https://stackoverflow.com/questions/29999024/adding-thousand-separator-to-int-in-swift

extension Formatter {
    static let number = NumberFormatter()
}

extension Locale {
    static let userLocale: Locale = .init(identifier: Locale.current.identifier)
    static let englishUS: Locale = .init(identifier: "en_US")
    static let frenchFR: Locale = .init(identifier: "fr_FR")
    static let portugueseBR: Locale = .init(identifier: "pt_BR")
}

extension Numeric {
    func formatted(with groupingSeparator: String? = nil, style: NumberFormatter.Style, locale: Locale = .current) -> String {
        Formatter.number.locale = locale
        Formatter.number.numberStyle = style
        Formatter.number.minimumFractionDigits = 0 //Delete 0 after digits
        if let groupingSeparator = groupingSeparator {
            Formatter.number.groupingSeparator = groupingSeparator
        }
        return Formatter.number.string(for: self) ?? ""
    }
    // Localized
    
    var currency: String { formatted(style: .currency, locale: .userLocale) }
    
    // Fixed locales
    var currencyUS: String { formatted(style: .currency, locale: .englishUS) }
    var currencyFR: String { formatted(style: .currency, locale: .frenchFR) }
    var currencyBR: String { formatted(style: .currency, locale: .portugueseBR) }
}
