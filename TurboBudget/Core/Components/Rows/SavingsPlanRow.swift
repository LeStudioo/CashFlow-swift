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
        VStack(alignment: .leading) {
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
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(uiColor: .label))
            }
            
            Spacer()
            
            Text(savingsPlan.name ?? "")
                .font(.semiBoldText16())
                .foregroundStyle(Color(uiColor: .label))
                .lineLimit(1)
                        
            progressBar()
                .padding(.bottom, 12)
                .padding(.top, -10)
            
        }
        .padding(12)
        .frame(height: 160)
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

    // MARK: Fonctions
    @ViewBuilder
    func progressBar() -> some View {
        VStack {
            GeometryReader { geometry in
                VStack(spacing: 5) {
                    HStack {
                        Spacer()
                        Text(formatNumber(savingsPlan.goalAmount ?? 0))
                    }
                    .font(.semiBoldVerySmall())
                    .foregroundStyle(Color(uiColor: .label))
                    
                    let widthCapsule = geometry.size.width * percentage
                    let widthAmount = formatNumber(savingsPlan.currentAmount ?? 0).widthOfString(usingFont: UIFont(name: nameFontSemiBold, size: 16)!) * increaseWidthAmount
                    
                    Capsule()
                        .frame(height: 24)
                        .foregroundStyle(Color.background200)
                        .overlay(alignment: .leading) {
                            Capsule()
                                .foregroundStyle(themeManager.theme.color)
                                .frame(width: widthCapsule < widthAmount ? widthAmount : widthCapsule)
                                .padding(3)
                                .overlay(alignment: .trailing) {
                                    Text(formatNumber(savingsPlan.currentAmount ?? 0))
                                        .padding(.trailing, 12)
                                        .font(.semiBoldVerySmall())
                                        .foregroundStyle(Color(uiColor: .systemBackground))
                                }
                        }
                }
            }
            .frame(height: 38)
        }
    }
} // struct

// MARK: - Preview
#Preview {
    SavingsPlanRow(savingsPlan: .mockClassicSavingsPlan)
        .frame(width: 180, height: 150)
}
