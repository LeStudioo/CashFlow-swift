//
//  SavingsPlanRow.swift
//  CashFlow
//
//  Created by Théo Sementa on 24/06/2023.
//

import SwiftUI

struct SavingsPlanRow: View {

    // Custom type
    var savingsPlan: SavingsPlanModel

    // Environnement
    @EnvironmentObject private var themeManager: ThemeManager

    // State or Binding Int, Float and Double
    @State private var percentage: Double = 0
    @State private var increaseWidthAmount: Double = 0

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.background200)
                    .cornerRadius(12)
                    .overlay {
                        Text(savingsPlan.emoji ?? "")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .shadow(radius: 2, y: 2)
                    }
                
                Spacer()
            }
                        
            Text(savingsPlan.name ?? "")
                .font(.semiBoldText16())
                .foregroundStyle(Color.text)
                .lineLimit(1)
                .frame(maxHeight: .infinity, alignment: .top)
                  
            VStack(spacing: 5) {
                HStack {
                    Spacer()
                    Text(formatNumber(savingsPlan.goalAmount ?? 0))
                }
                .font(.semiBoldVerySmall())
                .foregroundStyle(Color.text)
                
                ProgressBarWithAmount(
                    percentage: percentage,
                    value: savingsPlan.currentAmount ?? 0
                )
                .frame(height: 28)
            }
        }
        .padding(12)
        .aspectRatio(1, contentMode: .fit)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.background100)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring()) {
                    guard let currentAmount = savingsPlan.currentAmount, let goalAmount = savingsPlan.goalAmount else { return }
                    if currentAmount / goalAmount >= 0.96 {
                        percentage = 0.96
                    } else {
                        percentage = currentAmount / goalAmount
                    }
                    increaseWidthAmount = 1.1
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsPlanRow(savingsPlan: .mockClassicSavingsPlan)
        .environmentObject(ThemeManager())
        .frame(width: 180)
        .padding()
        .background(Color.background)
}
