//
//  CustomDatePickerWithToggle.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI

struct CustomDatePickerWithToggle: View {
    
    // Builder
    var title: String
    @Binding var date: Date
    @Binding var isEnabled: Bool
    var withRange: Bool = false
    
    @State private var isDatePickerShowing: Bool = false
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            VStack(alignment: .trailing, spacing: 0) {
                HStack {
                    Button(action: {
                        if isEnabled {
                            withAnimation { isDatePickerShowing.toggle() }
                        }
                    }, label: {
                        Text(date.formatted(Date.FormatStyle().day().month(.abbreviated).year()))
                            .foregroundStyle(Color.text)
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.background300)
                            }
                    })
                    .opacity(isEnabled ? 1 : 0.6)
                    
                    Spacer()
                    
                    Button {
                        withAnimation { isEnabled.toggle() }
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.text)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 20, height: 20)
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(isEnabled ? themeManager.theme.color : Color.background300)
                            }
                    }
                }
                .padding(8)
                
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
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.background200)
            }
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
}
