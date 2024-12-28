//
//  ProgressBarWithAmount.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import SwiftUI

struct ProgressBarWithAmount: View {
    
    // Builder
    var percentage: Double
    var value: Double
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var valueString: String {
        return formatNumber(value)
    }
    
    // MARK: -
    var body: some View {
        GeometryReader { geometry in
            let widthText = formatNumber(value).widthOfString(usingFont: UIFont(name: nameFontSemiBold, size: 16)!) * 1.4
            let widthPercentage = geometry.size.width * min(1, percentage)
            
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.background200)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(themeManager.theme.color)
                        .frame(width: max(widthText, widthPercentage))
                        .overlay(alignment: .trailing) {
                            Text(valueString)
                                .padding(.trailing, 8)
                                .font(.semiBoldVerySmall())
                                .foregroundStyle(Color(uiColor: .systemBackground))
                                .padding(.leading, 8)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                }
         }
    } // body
} // struct

// MARK: - Preview
#Preview {
    ProgressBarWithAmount(percentage: 0.4, value: 300)
        .frame(height: 38)
        .environmentObject(ThemeManager())
        .padding()
        .background(Color.background)
}
