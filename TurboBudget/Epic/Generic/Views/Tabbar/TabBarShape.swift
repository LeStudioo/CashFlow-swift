//
//  TabBarShape.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

// import SwiftUI
//
// struct TabBarShape: Shape {
//    func path(in rect: CGRect) -> Path {
//        return Path { path in
//            path.move(to: .zero)
//            path.addLine(to: CGPoint(x: rect.width / 2 - 48, y: 0))
//            
//            var pt1: CGPoint = .zero
//            var pt2: CGPoint = .zero
//            
//            pt1 = .init(x: rect.width / 2 - 48 + 5, y: 0)
//            pt2 = .init(x: rect.width / 2 - 48 - 10, y: 105)
//            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 10)
//            
//            let p3 = path.currentPoint!
//            path.addCurve(to: CGPoint(x: rect.width - p3.x, y: p3.y),
//                          control1: CGPoint(x: rect.width / 2 - 75, y: 102),
//                          control2: CGPoint(x: rect.width / 2 + 75, y: 102))
//            
//            pt1 = .init(x: rect.width / 2 + 48 - 10, y: 0)
//            pt2 = .init(x: rect.width / 2 + 48 + 10, y: 0)
//            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 10)
//            
//            path.addLine(to: CGPoint(x: rect.width, y: 0))
//            path.addLine(to: CGPoint(x: rect.width, y: 100))
//            path.addLine(to: CGPoint(x: 0, y: 100))
//            path.addLine(to: .zero)
//            path.closeSubpath()
//        }
//    }
// }

import SwiftUI

struct TabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            // Constants for better readability
            let width = rect.width
            let height: CGFloat = 100
            let centerX = width / 2
            let cutoutWidth: CGFloat = 96 // Total width of center cutout (48*2)
            let leftCutoutEdge = centerX - cutoutWidth / 2
            let rightCutoutEdge = centerX + cutoutWidth / 2
            
            let cornerRadius: CGFloat = 10
            path.move(to: .zero)
            
            // Draw line to start of left cutout curve
            path.addLine(to: CGPoint(x: leftCutoutEdge, y: 0))
            
            // Create curved left edge of cutout with corner radius
            let leftCurveStart = CGPoint(x: leftCutoutEdge + 5, y: 0)
            let leftCurveEnd = CGPoint(x: leftCutoutEdge - 10, y: height * 1.05)
            path.addArc(tangent1End: leftCurveStart, tangent2End: leftCurveEnd, radius: cornerRadius)
            
            // Store current point to use as reference for the bottom curve
            let bottomCurveStart = path.currentPoint!
            
            // Draw bottom curve connecting left and right sides of cutout
            path.addCurve(
                to: CGPoint(x: width - bottomCurveStart.x, y: bottomCurveStart.y),
                control1: CGPoint(x: centerX - 75, y: height * 1.02),
                control2: CGPoint(x: centerX + 75, y: height * 1.02)
            )
            
            // Create curved right edge of cutout with corner radius
            let rightCurveStart = CGPoint(x: rightCutoutEdge - 10, y: 0)
            let rightCurveEnd = CGPoint(x: rightCutoutEdge + 10, y: 0)
            path.addArc(tangent1End: rightCurveStart, tangent2End: rightCurveEnd, radius: cornerRadius)
            
            // Complete the rectangle
            path.addLine(to: CGPoint(x: width, y: 0))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: .zero)
            
            path.closeSubpath()
        }
    }
}
