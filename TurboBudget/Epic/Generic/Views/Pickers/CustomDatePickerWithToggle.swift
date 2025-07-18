//
//  CustomDatePickerWithToggle.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI
import TheoKit
import DesignSystemModule

struct CustomDatePickerWithToggle: View {
    
    // Builder
    var title: String
    @Binding var date: Date
    @Binding var isEnabled: Bool
    var withRange: Bool = false
    
    @State private var isDatePickerShowing: Bool = false
    @State private var datePickerHeight: CGFloat = 0
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            VStack(alignment: .trailing, spacing: 0) {
                HStack {
                    Button {
                        withAnimation { isEnabled.toggle() }
                    } label: {
                        Image(.iconCheck)
                            .renderingMode(.template)
                            .foregroundStyle(Color.label)
                            .padding(8)
                            .frame(width: self.datePickerHeight, height: self.datePickerHeight)
                            .roundedRectangleBorder(
                                isEnabled ? themeManager.theme.color : Color.background300,
                                radius: 8
                            )
                    }
                    
                    Spacer()
                    
                    Button {
                        if isEnabled {
                            withAnimation { isDatePickerShowing.toggle() }
                        }
                    } label: {
                        Text(date.formatted(Date.FormatStyle().day().month(.abbreviated).year()))
                            .contentTransition(.numericText())
                            .foregroundStyle(Color.label)
                            .fontWithLineHeight(.Body.medium)
                            .padding(Padding.medium)
                            .roundedRectangleBorder(
                                TKDesignSystem.Colors.Background.Theme.bg200,
                                radius: CornerRadius.small
                            )
                    }
                    .opacity(isEnabled ? 1 : 0.6)
                    .getSize { size in
                        self.datePickerHeight = size.height
                    }
                    
                }
                .padding(Padding.extraSmall)
                
                if isDatePickerShowing {
                    if withRange {
                        DatePicker("", selection: $date, in: Date()..., displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .tint(themeManager.theme.color)
                    } else {
                        DatePicker("", selection: $date, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .tint(themeManager.theme.color)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .roundedRectangleBorder(
                TKDesignSystem.Colors.Background.Theme.bg100,
                radius: CornerRadius.medium,
                lineWidth: 1,
                strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onChange(of: isEnabled) { newValue in
            if newValue == false {
                withAnimation { self.isDatePickerShowing = false }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CustomDatePickerWithToggle(
        title: "Preview title",
        date: .constant(.now),
        isEnabled: .constant(true)
    )
    .padding()
    .environmentObject(ThemeManager.shared)
    .preferredColorScheme(.dark)
}
