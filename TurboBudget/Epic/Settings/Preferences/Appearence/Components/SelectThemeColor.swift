//
//  SelectThemeColor.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/12/2024.
//

import SwiftUI
import StatsKit
import CoreModule

struct SelectThemeColor: View {
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack(spacing: 8) {
            Text(Word.Setting.Appearance.tintColor)
                .font(Font.mediumText16())
                .foregroundStyle(Color.customGray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(ThemeColor.allCases), id: \.self) { theme in
                        VStack {
                            Circle()
                                .frame(width: 30)
                                .foregroundStyle(theme.color)
                            Text(theme.name)
                                .font(Font.mediumText16())
                                .foregroundStyle(Color.customGray)
                        }
                        .padding()
                        .frame(width: 90, height: 90)
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.background100)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(
                                    themeManager.theme == theme ? theme.color : .clear,
                                    lineWidth: 3
                                )
                        }
                        .padding(4)
                        .onTapGesture {
                            themeManager.theme = theme
                            EventService.sendEvent(key: EventKeys.preferenceAppearanceTint)
                        }
                    }
                }
            } // ScrollView
            .scrollIndicators(.hidden)
        } // VStack
    } // body
} // struct

// MARK: - Preview
#Preview {
    SelectThemeColor()
        .padding()
        .background(Color.Background.bg50)
}
