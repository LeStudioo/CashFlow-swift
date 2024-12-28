//
//  ProgressBar.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI

struct ProgressBar: View {
    
    // Builder
    var percentage: Double
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var percentageString: String {
        return "\(Int(percentage * 100)) %"
    }
    
    // MARK: -
    var body: some View {
       GeometryReader { geometry in
           let widthText = percentageString
               .widthOfString(usingFont: UIFont(name: nameFontSemiBold, size: 16)!) * 1.8
           let widthPercentage = geometry.size.width * min(1, percentage)
           
           RoundedRectangle(cornerRadius: 16, style: .continuous)
               .fill(Color.background100)
               .overlay(alignment: .leading) {
                   RoundedRectangle(cornerRadius: 16, style: .continuous)
                       .fill(themeManager.theme.color)
                       .frame(width: max(widthText, widthPercentage))
                       .overlay(alignment: .trailing) {
                           Text(percentageString)
                               .padding(.trailing, 12)
                               .font(.semiBoldText16())
                               .foregroundStyle(Color(uiColor: .systemBackground))
                               .padding(.leading, 12)
                               .fixedSize(horizontal: true, vertical: false)
                       }
               }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        ProgressBar(percentage: 1)
            .frame(height: 48)
        ProgressBar(percentage: 0.48)
            .frame(height: 48)
    }
    .padding()
    .background(Color.background)
    .environmentObject(ThemeManager())
}
