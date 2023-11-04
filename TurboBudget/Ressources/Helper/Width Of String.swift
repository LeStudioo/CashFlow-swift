//
//  Width Of String.swift
//  CashFlow
//
//  Created by KaayZenn on 28/07/2023.
//

import Foundation
import SwiftUI

extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
