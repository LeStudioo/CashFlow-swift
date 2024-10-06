//
//  CustomSegmentedControl.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Refactor 17/02/2024

import SwiftUI

struct CustomSegmentedControl: View {

    // Builder
    var title: String
    @Binding var selection: ExpenseOrIncome
    var textLeft: String
    var textRight: String

    // Environement
    @Environment(\.colorScheme) private var colorScheme

    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            Button(action: {
                withAnimation(.spring().speed(1.25)) {
                    selection = (selection == .expense ? .income : .expense)
                }
                VibrationManager.vibration()
            }, label: {
                HStack(spacing: 0) {
                    Text(textLeft)
                        .font(.semiBoldText16())
                        .foregroundStyle(selection == .expense ? .white : (colorScheme == .light ? .secondary400 : .secondary300) )
                        .frame(maxWidth: .infinity)
                    
                    Text(textRight)
                        .font(.semiBoldText16())
                        .foregroundStyle(selection == .income ? .white : (colorScheme == .light ? .secondary400 : .secondary300) )
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background {
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .foregroundStyle(Color.backgroundComponentSheet)
                            .overlay(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .foregroundStyle(HelperManager().getAppTheme().color)
                                    .frame(width: (geo.size.width / 2))
                                    .offset(x: selection == .income ? (geo.size.width / 2) : 0)
                            }
                    }
                }
            })
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    @State var selectionPreview: ExpenseOrIncome = .income
    return CustomSegmentedControl(
        title: "Segmented Control",
        selection: $selectionPreview,
        textLeft: "Left",
        textRight: "Right"
    )
    .padding()
}
