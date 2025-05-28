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
    var icon: ImageResource
    var value: Double
    var color: Color
}
