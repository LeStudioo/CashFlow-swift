//
//  CustomEmptyView.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/10/2024.
//

import SwiftUI

struct CustomEmptyView: View {
    
    // builder
    var type: CustomEmptyViewType
    var isDisplayed: Bool
    
    // MARK: -
    var body: some View {
        VStack(spacing: 16) {
            Image(getEmptyImage() + ThemeManager.theme.nameNotLocalized.capitalized)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 4, y: 4)
                .frame(width:  UIScreen.main.bounds.width / (isIPad ? 3 : 1.5))
            
            Text(getDescription())
                .font(.semiBoldText16())
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .offset(y: -50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .isDisplayed(isDisplayed)
    } // body
    
    // MARK: - Functions
    private func getEmptyImage() -> String {
        switch type {
        case .empty(let situation):
            return situation.emptyImage
        case .noResults:
            return "NoResults"
        }
    }
    
    private func getDescription() -> String {
        switch type {
        case .empty(let situation):
            return situation.description
        case .noResults:
            return "word_no_results".localized
        }
    }
} // struct

// MARK: - Utils
enum CustomEmptyViewType: Equatable {
    case empty(situation: CustomEmptyViewSituation)
    case noResults
}

enum CustomEmptyViewSituation {
    case account
    case transactions
    case subscriptions
    case savingsPlan
    case analytics
    
    var emptyImage: String {
        switch self {
        case .account:
            return "NoAccount"
        case .transactions:
            return "NoTransaction"
        case .subscriptions:
            return "NoAutomations" // TODO: To edit to subscription
        case .savingsPlan:
            return "NoSavingPlan"
        case .analytics:
            return "NoIncome" // TODO: To edit
        }
    }
    
    var description: String {
        switch self {
        case .account:
            return "home_screen_no_account".localized
        case .transactions:
            return "word_no_transactions".localized
        case .subscriptions:
            return "word_no_automations".localized
        case .savingsPlan:
            return "error_message_savingsplan".localized
        case .analytics:
            return "analytic_home_no_stats".localized
        }
    }
}

// MARK: - Preview
#Preview {
    CustomEmptyView(
        type: .empty(situation: .account),
        isDisplayed: true
    )
}
