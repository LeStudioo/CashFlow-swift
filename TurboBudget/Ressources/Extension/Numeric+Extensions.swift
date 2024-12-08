//
//  Numeric+Extensions.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import Foundation

extension Numeric {
    
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        return formatter.string(for: self) ?? ""
    }
    
}
