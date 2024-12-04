//
//  ThemeCell.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/12/2024.
//

import SwiftUI

struct ThemeCell: View {
    
    // Builder
    var type: ColorScheme
    
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        Button(action: { csManager.colorScheme = type }, label: {
            VStack {
                background()
                    .frame(height: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                csManager.colorScheme == type ? themeManager.theme.color : Color.label,
                                lineWidth: csManager.colorScheme == type ? 3 : 1)
                        
                        if type == .light {
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .foregroundStyle(.black)
                        } else if type == .dark {
                            Image(systemName: "moon.fill")
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                        }
                    }
                Text(type.name)
                    .font(.semiBoldText16())
                    .foregroundStyle(Color(uiColor: .label))
            }
        })
    } // body
    
    @ViewBuilder
    func background() -> some View {
        switch type {
        case .unspecified:
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: .white, location: 0.5),
                            Gradient.Stop(color: .black, location: 0.5)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        case .light:
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
        case .dark:
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.black)
        }
    }
    
} // struct

// MARK: - Preview
#Preview {
    HStack(spacing: 8) {
        ThemeCell(type: .unspecified)
        ThemeCell(type: .light)
        ThemeCell(type: .dark)
    }
    .environmentObject(ColorSchemeManager())
    .environmentObject(ThemeManager())
    .padding()
}
