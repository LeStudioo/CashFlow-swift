//
//  Split Number.swift
//  CashFlow
//
//  Created by KaayZenn on 07/08/2023.
//

import Foundation
import SwiftUI

extension Double {
    
    func splitDecimal() -> (Int, Double) {
        let whole = Int(self)
        let decimal = self - Darwin.floor(self)
        
        return (whole, decimal)
    }
    
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self //Move the decimal right
        let truncated = Double(Int(newDecimal)) //Drop the fraction
        let originalDecimal = truncated / multiplier //Move the decimal back
        return originalDecimal
    }
    
    func rounded(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / 100
    }
    
    func roundedPlaces(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

func formatNumber(_ n: Double) -> String {
    let num = abs(n)
    let sign = (n < 0) ? "-" :  ""
    
    switch num {
    case 1_000_000_000...:
        var formatted = num / 1_000_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(currencySymbol)\(formatted)B"
        
    case 1_000_000...:
        var formatted = num / 1_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(currencySymbol)\(formatted)M"
        
    case 1_000...:
        var formatted = num / 1_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(currencySymbol)\(formatted)K"
        
    case 0...:
        return currencySymbol + String(format: "%.1f", n)
        
    default:
        return sign + currencySymbol + String(format: "%.1f", n)
    }
}
