//
//  CustomEmptyView.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/10/2024.
//

import SwiftUI
import NavigationKit
import TheoKit
import DesignSystemModule

struct CustomEmptyView: View {
    
    // builder
    var type: CustomEmptyViewType
    var isDisplayed: Bool
    
    @EnvironmentObject private var router: Router<AppDestination>
    
    var isHomeSituation: Bool {
        switch type {
        case .empty(let situation):
            switch situation {
            case .account:
                return false
            case .transactions(let style):
                return style == .home ? true : false
            case .subscriptions(let style):
                return style == .home ? true : false
            case .savingsPlan(let style):
                return style == .home ? true : false
            case .savingsAccount:
                return false
            case .analytics:
                return false
            }
        case .noResults:
            return false
        }
    }
    
    // MARK: -
    var body: some View {
        VStack(spacing: Spacing.small) {
            Image(emptyIcon)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                .frame(width: 32, height: 32)
            
            VStack(spacing: Spacing.extraSmall) {
                Text(emptyTitle)
                    .fontWithLineHeight(DesignSystem.Fonts.Body.large)
                    .foregroundStyle(Color.label)
                    
                Text(emptyDescription)
                    .fontWithLineHeight(DesignSystem.Fonts.Body.small)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg500)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(Padding.large)
        .frame(maxWidth: .infinity, maxHeight: isHomeSituation ? nil : .infinity)
        .roundedRectangleBorder(
            isHomeSituation ? TKDesignSystem.Colors.Background.Theme.bg100 : .clear,
            radius: TKDesignSystem.Radius.standard,
            lineWidth: isHomeSituation ? 0.5 : 0,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
        .isDisplayed(isDisplayed)
        .onTapGesture {
            if isHomeSituation {
                action()
            }
        }
    }
    
    var emptyIcon: ImageResource {
        switch type {
        case .empty(let situation):
            return situation.icon
        case .noResults:
            return .iconSearch
        }
    }
    
    var emptyDescription: String {
        switch type {
        case .empty(let situation):
            return situation.description.localized
        case .noResults:
            return "empty_search_description".localized
        }
    }
    
    var emptyTitle: String {
        switch type {
        case .empty(let situation):
            return situation.title.localized
        case .noResults(let searchText):
            return "word_no_results".localized + " " + "\"\(searchText)\""
        }
    }

    private func action() {
        switch type {
        case .empty(let situation):
            situation.action(router: router)
        case .noResults:
            break
        }
    }
} // struct

// MARK: - Utils
enum CustomEmptyViewType: Equatable {
    case empty(_ situation: CustomEmptyViewSituation)
    case noResults(_ searchText: String)
}

enum CustomEmptyViewSituationStyle: Equatable {
    case home
    case list
}

enum CustomEmptyViewSituation: Equatable {
    case account
    case transactions(CustomEmptyViewSituationStyle)
    case subscriptions(CustomEmptyViewSituationStyle)
    case savingsPlan(CustomEmptyViewSituationStyle)
//    case contributions
    case savingsAccount
    case analytics
    
    var icon: ImageResource {
        switch self {
        case .account:
            return .iconPerson
        case .transactions:
            return .iconBanknote
        case .subscriptions:
            return .iconClockRepeat
        case .savingsPlan:
            return .iconPiggyBank
//        case .contributions:
//            return .iconHandCoins
        case .savingsAccount:
            return .iconLandmark
        case .analytics:
            return .iconLineChart
        }
    }
    
    var title: String {
        switch self {
        case .account:
            return "empty_account_title"
        case .transactions:
            return "empty_transactions_title"
        case .subscriptions:
            return "empty_subscriptions_title"
        case .savingsPlan:
            return "empty_savingsplan_title"
        case .savingsAccount:
            return "empty_savingsaccount_title"
        case .analytics:
            return "empty_stats_title"
        }
    }
    
    var description: String {
        switch self {
        case .account:
            return "empty_account_list_description"
        case .transactions(let style):
            return style == .list ? "empty_transactions_list_description" : "empty_transactions_home_description"
        case .subscriptions(let style):
            return style == .list ? "empty_subscriptions_list_description" : "empty_subscription_home_description"
        case .savingsPlan(let style):
            return style == .list ? "empty_savingsplan_list_description" : "empty_savingsplan_home_description"
        case .savingsAccount:
            return "empty_savingsaccount_list_description"
        case .analytics:
            return "empty_stats_list_description"
        }
    }
    
    func action(router: Router<AppDestination>) {
        switch self {
        case .account:
            router.present(route: .sheet, .account(.create))
        case .transactions:
            router.push(.transaction(.create))
        case .subscriptions:
            router.push(.subscription(.create))
        case .savingsPlan:
            router.push(.savingsPlan(.create))
        case .savingsAccount:
            router.push(.savingsAccount(.create))
        case .analytics:
            router.push(.transaction(.create))
        }
    }
}

// MARK: - Preview
#Preview {
    CustomEmptyView(
        type: .empty(.account),
        isDisplayed: true
    )
}
