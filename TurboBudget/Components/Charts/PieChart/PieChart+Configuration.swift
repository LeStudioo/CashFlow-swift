//
//  PieChart+Configuration.swift
//  CustomPieChart
//
//  Created by KaayZenn on 11/08/2024.
//

import Foundation

extension PieChart {
    
    struct Configuration {
        
        var style: PieChartStyle
        var pieSizeRatio: Double
        var lineWidthMultiplier: Double
        var holeSizeRatio: Double
        var height: CGFloat
        
        init(
            style: PieChartStyle = .category,
            space: Double = 0,
            hole: Double = 0,
            pieSizeRatio: Double = 0.8,
            height: CGFloat = 240
        ) {
            self.style = style
            self.pieSizeRatio = min(max(pieSizeRatio, 0), 1)
            self.lineWidthMultiplier = min(max(space, 0), 1) / 10
            self.holeSizeRatio = min(max(hole, 0), 1)
            self.height = height
        }
    }
}
