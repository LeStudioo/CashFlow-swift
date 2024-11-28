//
//  PieSliceData.swift
//  CustomPieChart
//
//  Created by KaayZenn on 10/08/2024.
//

import Foundation
import SwiftUI

struct PieSliceData: Hashable {
    var categoryID: Int
    var subcategoryID: Int?
    var iconName: String
    var value: Double
    var color: Color
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(categoryID)
        hasher.combine(subcategoryID)
        hasher.combine(iconName)
        hasher.combine(value)
        hasher.combine(color)
    }
    
    static func == (lhs: PieSliceData, rhs: PieSliceData) -> Bool {
        lhs.categoryID == rhs.categoryID &&
        lhs.subcategoryID == rhs.subcategoryID &&
        lhs.iconName == rhs.iconName &&
        lhs.value == rhs.value &&
        lhs.color == rhs.color
    }
}
