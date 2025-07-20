////
////  Split Number.swift
////  CashFlow
////
////  Created by KaayZenn on 07/08/2023.
////
//
//import Foundation
//import SwiftUI
//
//extension Double {
//    
//    func reduceScale(to places: Int) -> Double {
//        let multiplier = pow(10, Double(places))
//        let newDecimal = multiplier * self // Move the decimal right
//        let truncated = Double(Int(newDecimal)) // Drop the fraction
//        let originalDecimal = truncated / multiplier // Move the decimal back
//        return originalDecimal
//    }
//    
//    func rounded(places: Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return (self * divisor).rounded() / 100
//    }
//
//}
//
//func formatNumber(_ n: Double) -> String {
//    let num = abs(n)
//    let sign = (n < 0) ? "-" :  ""
//    
//    switch num {
//    case 1_000_000_000...:
//        var formatted = num / 1_000_000_000
//        formatted = formatted.reduceScale(to: 1)
//        return "\(sign)\(UserCurrency.symbol)\(formatted)B"
//        
//    case 1_000_000...:
//        var formatted = num / 1_000_000
//        formatted = formatted.reduceScale(to: 1)
//        return "\(sign)\(UserCurrency.symbol)\(formatted)M"
//        
//    case 1_000...:
//        var formatted = num / 1_000
//        formatted = formatted.reduceScale(to: 1)
//        return "\(sign)\(UserCurrency.symbol)\(formatted)K"
//        
//    case 0...:
//        return n.toCurrency()
//        
//    default:
//        return n.toCurrency()
//    }
//}
