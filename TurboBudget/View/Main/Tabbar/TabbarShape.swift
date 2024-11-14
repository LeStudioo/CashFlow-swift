//
//  TabbarShape.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import SwiftUI

struct TabbarShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: rect.width / 2 - 48, y: 0))
            
            var pt1: CGPoint = .zero
            var pt2: CGPoint = .zero
            
            pt1 = .init(x: rect.width / 2 - 48 + 5, y: 0)
            pt2 = .init(x: rect.width / 2 - 48 - 10, y: 105)
            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 10)
            
            let p3 = path.currentPoint!
            path.addCurve(to: CGPoint(x: rect.width - p3.x, y: p3.y),
                          control1: CGPoint(x: rect.width / 2 - 75, y: 102),
                          control2: CGPoint(x: rect.width / 2 + 75, y: 102))
            
            pt1 = .init(x: rect.width / 2 + 48 - 10, y: 0)
            pt2 = .init(x: rect.width / 2 + 48 + 10, y: 0)
            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 10)
            
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: 0, y: 100))
            path.addLine(to: .zero)
            path.closeSubpath()
        }
    }
}
