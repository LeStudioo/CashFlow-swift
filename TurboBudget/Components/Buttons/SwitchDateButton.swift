//
//  SwitchDateButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import SwiftUI

enum SwitchDateButtonType {
    case month, year
}

struct SwitchDateButton: View {
    
    // Builder
    @Binding var date: Date
    var type: SwitchDateButtonType
    
    // MARK: -
    var body: some View {
        HStack {
            Button {
                changePeriodDate(inPast: true)
                VibrationManager.vibration()
            } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 16, height: 16)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.text)
            }

            Text(dateDisplayed())
                .font(.Body.semibold)
                .frame(maxWidth: .infinity)
                .animation(.smooth, value: date)
            
            Button {
                changePeriodDate(inPast: false)
                VibrationManager.vibration()
            } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 16, height: 16)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.text)
            }
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.background200)
        }
    } // body
    
    func dateDisplayed() -> String {
        switch type {
        case .month:
            return date.formatted(Date.FormatStyle().month(.wide)).capitalized
        case .year:
            return date.formatted(Date.FormatStyle().year())
        }
    }
    
    func changePeriodDate(inPast: Bool) {
        if inPast {
            switch type {
            case .month:
                date = date.oneMonthAgo.startOfMonth
            case .year:
                print("🔥 ACTUAL DATE : \(date)")
                date = date.oneYearAgo.startOfYear
            }
        } else {
            switch type {
            case .month:
                date = date.inOneMonth.startOfMonth
            case .year:
                date = date.inOneYear.startOfMonth
            }
        }
    }
    
} // struct

// MARK: - Preview
#Preview {
    SwitchDateButton(
        date: .constant(.now),
        type: .year
    )
}
