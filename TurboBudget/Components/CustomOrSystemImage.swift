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
    
    // MARK: -
    var body: some View {
        if let _ = UIImage(systemName: systemImage) {
            Image(systemName: systemImage)
                .font(.system(size: size, weight: .semibold, design: .rounded))
                .foregroundStyle(.black)
        } else {
            Image("\(systemImage)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size * 2, height: size * 2)
        }
    } // End body
} // End struct
