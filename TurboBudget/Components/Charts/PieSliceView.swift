//
//  PieSliceView.swift
//  CashFlow
//
//  Created by Théo Sementa on 28/06/2023.
//

import Foundation
import SwiftUI

@available(OSX 10.15, *)
struct PieSlice: View {
    var pieSliceData: PieSliceData
    
    var isGap: Bool
    var bigSymbol: Bool
    
    var midRadians: Double {
        return Double.pi / 2.0 - (pieSliceData.startAngle + pieSliceData.endAngle).radians / 2.0
    }
    
    var body: some View {
        
        let gapsize = isGap ? Angle(degrees: 5) / 2 : Angle(degrees: 0)
        
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    path.move(
                        to: CGPoint(
                            x: width * 0.5,
                            y: height * 0.5
                        )
                    )
                    
                    path.addArc(center: CGPoint(x: width * 0.5, y: height * 0.5), radius: width * 0.5, startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle + gapsize, endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle, clockwise: false)
                    
                }
                .fill(pieSliceData.color)
                
                Image(systemName: pieSliceData.iconName)
                    .foregroundStyle(Color.black)
                    .font(.system(size: bigSymbol ? 18 : 14, weight: .medium, design: .rounded))
                    .position(
                        x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(self.midRadians)),
                        y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.78 * sin(self.midRadians))
                    )
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

@available(OSX 10.15, *)

struct PieSliceData: Hashable {
    var startAngle: Angle
    var endAngle: Angle
    var iconName: String
    var value: Double
    var percentage: String
    var color: Color
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(startAngle)
        hasher.combine(endAngle)
        hasher.combine(iconName)
        hasher.combine(value)
        hasher.combine(percentage)
        hasher.combine(color)
    }
    
    static func == (lhs: PieSliceData, rhs: PieSliceData) -> Bool {
        return lhs.startAngle == rhs.startAngle &&
               lhs.endAngle == rhs.endAngle &&
               lhs.iconName == rhs.iconName &&
               lhs.value == rhs.value &&
               lhs.percentage == rhs.percentage &&
               lhs.color == rhs.color
    }
}
@available(OSX 10.15.0, *)
struct PieSlice_Previews: PreviewProvider {
    static var previews: some View {
        PieSlice(pieSliceData: PieSliceData(startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 120.0), iconName: "sun.max", value: 500, percentage: "30%", color: Color.black), isGap: true, bigSymbol: true)
    }
}
