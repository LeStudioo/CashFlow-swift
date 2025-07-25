//
//  SavingsPlanListScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 20/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import NavigationKit
import StatsKit
import TheoKit
import DesignSystemModule
import CoreModule

struct SavingsPlanListScreen: View {
    
    // Environment
    @EnvironmentObject private var savingsPlanStore: SavingsPlanStore
    @EnvironmentObject private var contributionStore: ContributionStore
    @EnvironmentObject private var router: Router<AppDestination>
        
    // String variables
    @State private var searchText: String = ""
        
    // Computed var
    private var searchResults: [SavingsPlanModel] {
        return savingsPlanStore.savingsPlans.search(searchText)
    }
    
    // Other
    private let layout: [GridItem] = [GridItem(.flexible(minimum: 40), spacing: 16), GridItem(.flexible(minimum: 40), spacing: 16)]
    
    // MARK: -
    var body: some View {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: Word.Main.savingsPlans,
                actionButton: .init(
                    title: Word.Classic.create,
                    action: { router.push(.savingsPlan(.create)) },
                    isDisabled: false
                ),
                placeholder: "word_search".localized,
                searchText: $searchText.animation()
            )
        } content: { _ in
            LazyVGrid(columns: layout, alignment: .center) {
                ForEach(searchResults) { savingsPlan in
                    NavigationButton(
                        route: .push,
                        destination: AppDestination.savingsPlan(.detail(savingsPlan: savingsPlan)),
                        onNavigate: {
                            Task {
                                if let savingsPlanID = savingsPlan.id {
                                    await contributionStore.fetchContributions(savingsplanID: savingsPlanID)
                                }
                            }
                        },
                        label: {
                            SavingsPlanRowView(savingsPlan: savingsPlan)
                        }
                    )
                    .padding(.bottom)
                }
            }
            .padding(.horizontal, Padding.large)
        }
        .overlay {
            CustomEmptyView(
                type: (searchResults.isEmpty && !searchText.isEmpty) ? .noResults(searchText) : .empty(.savingsPlan(.list)),
                isDisplayed: savingsPlanStore.savingsPlans.isEmpty || (searchResults.isEmpty && !searchText.isEmpty)
            )
        }
        .navigationBarBackButtonHidden(true)
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .onAppear {
            EventService.sendEvent(key: EventKeys.savingsplanListPage)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsPlanListScreen()
}
