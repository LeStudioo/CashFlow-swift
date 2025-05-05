//
//  CustomDatePicker.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI
import TheoKit

struct CustomDatePicker: View {
    
    // Builder
    var title: String
    @Binding var date: Date
    var onlyFutureDates: Bool = false
    
    @State private var isDatePickerShowing: Bool = false
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            VStack(alignment: .trailing, spacing: 0) {
                Button(action: {
                    withAnimation { isDatePickerShowing.toggle() }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }, label: {
                    Text(date.formatted(Date.FormatStyle().day().month(.abbreviated).year()))
                        .contentTransition(.numericText())
                        .foregroundStyle(Color.label)
                        .font(DesignSystem.Fonts.Body.medium)
                        .padding(TKDesignSystem.Padding.medium)
                        .roundedRectangleBorder(
                            TKDesignSystem.Colors.Background.Theme.bg200,
                            radius: TKDesignSystem.Radius.small
                        )
                })
                .padding(TKDesignSystem.Padding.extraSmall)
                .animation(.smooth, value: date)
                
                if isDatePickerShowing {
                    if onlyFutureDates {
                        DatePicker("", selection: $date, in: tomorrow..., displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .tint(themeManager.theme.color)
                    } else {
                        DatePicker("", selection: $date, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .tint(themeManager.theme.color)
                    }
                }
            }
            .fullWidth(.trailing)
            .roundedRectangleBorder(
                TKDesignSystem.Colors.Background.Theme.bg100,
                radius: TKDesignSystem.Radius.medium,
                lineWidth: 1,
                strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
            )
        }
        .fullWidth(.leading)
        .onAppear {
            if onlyFutureDates {
                date = tomorrow
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CustomDatePicker(
        title: "Preview title",
        date: .constant(.now)
    )
    .padding()
}
