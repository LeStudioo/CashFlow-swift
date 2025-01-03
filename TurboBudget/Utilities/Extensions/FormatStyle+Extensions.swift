//
//  FormatStyle+Extensions.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import Foundation

extension FormatStyle where Self == Date.FormatStyle {
    
    static var monthAndYear: Date.FormatStyle {
        return Date.FormatStyle().month(.wide).year()
    }
    
}
