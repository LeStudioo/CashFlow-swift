//
//  CustomDatePicker.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI

struct CustomDatePicker: View {
    
    // Builder
    var title: String
    @Binding var date: Date
    var onlyFutureDates: Bool = false
    
    @State private var isDatePickerShowing: Bool = false
    
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
                        .foregroundStyle(Color.text)
                        .padding(8)
                        .background {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.background300)
                        }
                })
                .padding(8)
                
                if isDatePickerShowing {
                    if onlyFutureDates {
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
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.background200)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
