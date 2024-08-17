//
//  PieChart+Extensions.swift
//  CustomPieChart
//
//  Created by KaayZenn on 11/08/2024.
//

import SwiftUI

extension PieChart {
    
    init(
        slices: [PieSliceData],
        backgroundColor: Color = .init(UIColor.systemBackground),
        configuration: Configuration = .init()
    ) {
        self.slices = slices
        self.backgroundColor = backgroundColor
        self.chartStyle = configuration.style
        self.pieSizeRatio = configuration.pieSizeRatio
        self.lineWidthMultiplier = configuration.lineWidthMultiplier
        self.holeSizeRatio = configuration.holeSizeRatio
        self.height = configuration.height
        self.isInteractive = configuration.isInteractive
    }
    
    static func adjustValues(_ inputValues: [Double]) -> [Double] {
        let total = inputValues.reduce(0, +)
        let minValue = total * 0.06 // 10% du total
        
        let adjustedValues = inputValues.map { max($0, minValue) }
        let newTotal = adjustedValues.reduce(0, +)
        
        // Normaliser les valeurs pour que leur somme soit toujours égale à 100%
        return adjustedValues.map { $0 / newTotal * total }
    }
}
