//
//  ProgressBarWithAmount.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import SwiftUI
import CoreModule

struct ProgressBarWithAmount: View {
    
    // Builder
    var percentage: Double
    var value: Double
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var progressBarWidth: CGFloat = 0
    
    var valueString: String {
        return formatNumber(value)
    }
    
    // MARK: -
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.background200)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(themeManager.theme.color)
                        .frame(width: progressBarWidth)
                        .overlay(alignment: .trailing) {
                            Text(valueString)
                                .opacity(progressBarWidth != 0 ? 1 : 0)
                                .padding(.trailing, 8)
                                .font(.semiBoldVerySmall())
                                .foregroundStyle(Color(uiColor: .systemBackground))
                                .padding(.leading, 8)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .animation(.smooth.delay(0.3), value: progressBarWidth)
                }
                .onAppear {
                    let widthText = formatNumber(value).width(usingFont: UIFont(name: "PlusJakartaSans-SemiBold", size: 16)!) * 1.4 // TODO: Need refactor
                    let widthPercentage = geometry.size.width * min(1, percentage)
                    progressBarWidth = max(widthText, widthPercentage)
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
