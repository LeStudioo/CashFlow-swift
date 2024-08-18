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
    @Binding var selection: ExpenseOrIncome
    var textLeft: String
    var textRight: String
    var height: CGFloat

    // Environement
    @Environment(\.colorScheme) private var colorScheme

    // Number variables
    @State private var newX: CGFloat = 0

    // MARK: - body
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .frame(height: height)
                    .foregroundStyle(Color.backgroundComponentSheet)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundStyle(HelperManager().getAppTheme().color)
                            .frame(width: (geo.size.width / 2))
                            .padding(2)
                            .offset(x: newX)
                        
                        Text(textLeft)
                            .font(.semiBoldText18())
                            .foregroundStyle(selection == .expense ? .white : (colorScheme == .light ? .secondary400 : .secondary300) )
                    }
                
                Text(textRight)
                    .font(.semiBoldText18())
                    .foregroundStyle(selection == .income ? .white : (colorScheme == .light ? .secondary400 : .secondary300) )
                    .offset(x: geo.size.width / 4)
            }
            .onTapGesture {
                withAnimation(.spring().speed(1.25)) {
                    if selection == .expense {
                        selection = .income
                        newX = geo.size.width / 2 - 4
                    } else if selection == .income {
                        selection = .expense
                        newX = 0
                    }
                }
                VibrationManager.vibration()
            }
            .onChange(of: selection) { _ in
                withAnimation(.spring().speed(1.25)) {
                    if selection == .expense {
                        newX = 0
                    } else if selection == .income {
                        newX = geo.size.width / 2 - 4
                    }
                }
                VibrationManager.vibration()
            }
        }
        .frame(height: height)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    @State var selectionPreview: ExpenseOrIncome = .expense
    return CustomSegmentedControl(
        selection: $selectionPreview,
        textLeft: "Left",
        textRight: "Right",
        height: 30
    )
    .padding()
}
