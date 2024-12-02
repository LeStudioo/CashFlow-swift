//
//  ContributionRow.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import SwipeActions

struct ContributionRow: View {

    // Builder
    var savingsPlan: SavingsPlanModel
    var contribution: ContributionModel

    //Environnement
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var alertManager: AlertManager
    
    // MARK: -
    var body: some View {
        SwipeView(label: {
            HStack {
                Text(contribution.amount ?? 0 < 0 ? "contribution_cell_withdrawn".localized : "contribution_cell_added".localized)
                    .font(Font.mediumText16())
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text(contribution.amount?.currency ?? "")
                        .font(.semiBoldText16())
                        .foregroundStyle(contribution.amount ?? 0 < 0 ? .error400 : .primary500)
                    
                    Text(HelperManager().stringDateDay(date: contribution.date))
                        .font(Font.mediumSmall())
                        .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                }
            }
            .padding(12)
            .padding(.horizontal, 4)
            .background(Color.colorCell)
            .cornerRadius(15)
        }, trailingActions: { context in
            SwipeAction(action: {
                alertManager.deleteContribution(
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
        .padding(.horizontal, 12)
        .padding(.vertical, 2)
    } // body
} // struct

// MARK: - Preview
#Preview {
    ContributionRow(savingsPlan: .mockClassicSavingsPlan, contribution: .mockContribution)
}
