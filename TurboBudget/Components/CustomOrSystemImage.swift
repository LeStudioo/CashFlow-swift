//
//  CustomOrSystemImage.swift
//  CashFlow
//
//  Created by KaayZenn on 12/08/2024.
//

import SwiftUI

struct CustomOrSystemImage: View {
    
    // Builder
    var systemImage: String
    var size: CGFloat
    var color: Color = .black
    
    // MARK: -
    var body: some View {
        if UIImage(systemName: systemImage) != nil {
            Image(systemName: systemImage)
                .font(.system(size: size, weight: .semibold, design: .rounded))
                .frame(width: size * 1.8, height: size * 1.8)
                .foregroundStyle(color)
        } else {
            Image("\(systemImage)")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
                .frame(width: size * 1.8, height: size * 1.8)
        }
    } // End body
} // End struct

#Preview {
    HStack {
        Image(systemName: "sun.max")
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .frame(width: 10 * 1.8, height: 10 * 1.8)
            .background(Color.blue)
        Image(systemName: "person.fill")
            .frame(width: 10 * 1.8, height: 10 * 1.8)
            .background(Color.red)
        Image(systemName: "house.fill")
            .frame(width: 10 * 1.8, height: 10 * 1.8)
            .background(Color.green)
    }
}
