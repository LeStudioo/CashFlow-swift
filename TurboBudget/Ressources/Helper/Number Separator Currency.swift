//
//  Number Separator Currency.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

// TODO: Delete this file

import Foundation
import SwiftUI

// https://stackoverflow.com/questions/29999024/adding-thousand-separator-to-int-in-swift

extension Formatter {
    static let number = NumberFormatter()
}

extension Locale {
    static let userLocale: Locale = .init(identifier: Locale.current.identifier)
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
    
    var currency: String { formatted(style: .currency, locale: .userLocale) }
}


