//
//  ContributionRow.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import SwipeActions
import AlertKit

struct ContributionRow: View {

    // Builder
    var savingsPlan: SavingsPlanModel
    var contribution: ContributionModel
    
    // MARK: -
    var body: some View {
        SwipeView(label: {
            HStack {
                Text(contribution.type == .withdrawal ? "contribution_cell_withdrawn".localized : "contribution_cell_added".localized)
                    .font(Font.mediumText16())
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(contribution.symbol) \(contribution.amount?.toCurrency() ?? "")")
                        .font(.semiBoldText16())
                        .foregroundStyle(contribution.type == .withdrawal ? .error400 : .primary500)
                    
                    Text(contribution.date.formatted(date: .numeric, time: .omitted))
                        .font(Font.mediumSmall())
                        .foregroundStyle(Color.customGray)
                }
            }
            .padding(12)
            .padding(.horizontal, 4)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.background100)
            }
        }, trailingActions: { context in
            SwipeAction(action: {
                AlertManager.shared.deleteContribution(
                    savingsPlan: savingsPlan,
                    contribution: contribution
                )
                context.state.wrappedValue = .closed
            }, label: { _ in
                VStack(spacing: 5) {
                    Image(systemName: "trash")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    Text("word_DELETE".localized)
                        .font(.semiBoldCustom(size: 10))
                }
                .foregroundStyle(Color(uiColor: .systemBackground))
            }, background: { _ in
                Rectangle()
                    .foregroundStyle(.error400)
            })
            .allowSwipeToTrigger()
        })
        .swipeActionsStyle(.cascade)
        .swipeActionCornerRadius(15)
        .swipeMinimumDistance(30)
        .padding(.vertical, 2)
    } // body
} // struct

// MARK: - Preview
#Preview {
    ContributionRow(savingsPlan: .mockClassicSavingsPlan, contribution: .mockContribution)
}
