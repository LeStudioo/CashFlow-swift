//
//  TextFieldFormatter.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/12/2024.
//

import Foundation

struct TextFieldFormatter {
    enum FormatType {
        case creditCard
    }
    
    let type: FormatType
    
    func format(_ input: String) -> String {
        
        let limitedInput: Substring
        switch type {
        case .creditCard:
            let cleanInput = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            limitedInput = cleanInput.prefix(16)
        }
        
        switch type {
        case .creditCard:
            return limitedInput.enumerated()
                .map { $0.offset > 0 && $0.offset % 4 == 0 ? " " + String($0.element) : String($0.element) }
                .joined()
        }
    }
}
