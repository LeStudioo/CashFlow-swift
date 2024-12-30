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
    @EnvironmentObject private var savingsPlanStore: SavingsPlanStore
    
    var currentSavingsPlan: SavingsPlanModel {
        return savingsPlanStore.savingsPlans.first { $0.id == savingsPlan.id } ?? savingsPlan
    }

    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.background200)
                    .cornerRadius(12)
                    .overlay {
                        Text(currentSavingsPlan.emoji ?? "")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .shadow(radius: 2, y: 2)
                    }
                
                Spacer()
            }
                        
            Text(currentSavingsPlan.name ?? "")
                .font(.semiBoldText16())
                .foregroundStyle(Color.text)
                .lineLimit(1)
                .frame(maxHeight: .infinity, alignment: .top)
                  
            VStack(spacing: 5) {
                HStack {
                    Spacer()
                    Text(formatNumber(currentSavingsPlan.goalAmount ?? 0))
                }
                .font(.semiBoldVerySmall())
                .foregroundStyle(Color.text)
                
                ProgressBarWithAmount(
                    percentage: currentSavingsPlan.percentageComplete,
                    value: currentSavingsPlan.currentAmount ?? 0
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
