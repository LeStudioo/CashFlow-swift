//
//  CustomEmptyView.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/10/2024.
//

import SwiftUI
import NavigationKit

struct CustomEmptyView: View {
    
    // builder
    var type: CustomEmptyViewType
    var isDisplayed: Bool
    
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var router: Router<AppDestination>
    
    var isSituation: Bool {
        switch type {
        case .empty(let situation):
            switch situation {
            case .contributions: return false
            default: return true
            }
        case .noResults:    return false
        }
    }
    
    // MARK: -
    var body: some View {
        VStack(spacing: 16) {
            Image(getEmptyImage() + themeManager.theme.nameNotLocalized.capitalized)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 4, y: 4)
                .frame(width: UIScreen.main.bounds.width / (UIDevice.isIpad ? 3 : 1.5))
            
            Text(getDescription())
                .font(.semiBoldText16())
                .multilineTextAlignment(.center)
            
            if isSituation {
                Button(action: action) {
                    Text(createText)
                        .foregroundStyle(Color.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            Capsule()
                                .fill(themeManager.theme.color)
                        }
                }
            }
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
        case .noResults(let searchText):
            return "word_no_results".localized + " " + searchText
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
    
    private var createText: String {
        switch type {
        case .empty(let situation):
            return situation.createText
        case .noResults:
            return ""
        }
    }
} // struct

// MARK: - Utils
enum CustomEmptyViewType: Equatable {
    case empty(_ situation: CustomEmptyViewSituation)
    case noResults(_ searchText: String)
}

enum CustomEmptyViewSituation {
    case account
    case transactions
    case subscriptions
    case savingsPlan
    case contributions
    case savingsAccount
    case analytics
    
    var emptyImage: String {
        switch self {
        case .account:
            return "NoAccount"
        case .transactions:
            return "NoTransaction"
        case .subscriptions:
            return "NoAutomation" // TBL To edit to subscription
        case .savingsPlan:
            return "NoSavingPlan"
        case .contributions:
            return "NoSavingPlan"
        case .savingsAccount:
            return "NoSavingPlan"
        case .analytics:
            return "NoIncome" // TBL To edit
        }
    }
    
    var description: String {
        switch self {
        case .account:
            return Word.Empty.Account.desc
        case .transactions:
            return Word.Empty.Transaction.desc
        case .subscriptions:
            return Word.Empty.Subscription.desc
        case .savingsPlan:
            return Word.Empty.SavingsPlan.desc
        case .contributions:
            return Word.Empty.Contribution.desc
        case .savingsAccount:
            return Word.Empty.SavingsAccount.desc
        case .analytics:
            return "analytic_home_no_stats".localized
        }
    }
    
    var createText: String {
        switch self {
        case .account:
            return Word.Empty.Account.create
        case .transactions:
            return Word.Empty.Transaction.create
        case .subscriptions:
            return Word.Empty.Subscription.create
        case .savingsPlan:
            return Word.Empty.SavingsPlan.create
        case .contributions:
            return ""
        case .savingsAccount:
            return Word.Empty.SavingsAccount.create
        case .analytics:
            return Word.Empty.Transaction.create
        }
    }
    
    func action(router: Router<AppDestination>) {
        switch self {
        case .account:
            router.present(route: .sheet, .account(.create))
        case .transactions:
            router.present(route: .sheet, .transaction(.create))
        case .subscriptions:
            router.present(route: .sheet, .subscription(.create))
        case .savingsPlan:
            router.present(route: .sheet, .savingsPlan(.create))
        case .savingsAccount:
            router.present(route: .sheet, .savingsAccount(.create))
        case .contributions:
            break
        case .analytics:
            router.present(route: .sheet, .transaction(.create))
        }
    }
}

// MARK: - Preview
#Preview {
    CustomEmptyView(
        type: .empty(.account),
        isDisplayed: true
    )
    .environmentObject(ThemeManager())
}
