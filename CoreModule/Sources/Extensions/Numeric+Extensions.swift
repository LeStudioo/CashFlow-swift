//
//  Numeric+Extensions.swift
//  CoreModule
//
//  Created by Theo Sementa on 20/07/2025.
//

import Foundation

public extension Numeric {
    
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        return formatter.string(for: self) ?? ""
    }
    
}
