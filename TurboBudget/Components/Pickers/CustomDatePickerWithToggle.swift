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
    
    @State private var isDatePickerShowing: Bool = false
    
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
                            .foregroundStyle(Color.label)
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.componentInComponent)
                            }
                    })
                    .opacity(isEnabled ? 1 : 0.6)
                    
                    Spacer()
                    
                    Button {
                        withAnimation { isEnabled.toggle() }
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.label)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 20, height: 20)
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(isEnabled ? HelperManager().getAppTheme().color : Color.componentInComponent)
                            }
                    }
                }
                .padding(8)
                
                if isDatePickerShowing {
                    DatePicker("", selection: $date, in: Date()..., displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .tint(HelperManager().getAppTheme().color)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.backgroundComponentSheet)
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
