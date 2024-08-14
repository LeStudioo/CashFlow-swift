//
//  String.swift
//  CashFlow
//
//  Created by KaayZenn on 10/09/2023.
//

import Foundation
import SwiftUI

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
         let fontAttributes = [NSAttributedString.Key.font: font]
         let size = self.size(withAttributes: fontAttributes)
         return size.width
     }
    
    func convertToDouble() -> Double {
        let stringFormated = self.replacingOccurrences(of: ",", with: ".")
        return Double(stringFormated) ?? 0
    }
    
    func isEmptyWithoutSpace() -> Bool {
        if self.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil).isEmpty {
            return true
        } else { return false }
    }
    
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
