//
//  SavingsPlansHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 20/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import NavigationKit
import StatsKit

struct SavingsPlansHomeView: View {
    
    // Environment
    @EnvironmentObject private var savingsPlanStore: SavingsPlanStore
    @EnvironmentObject private var contributionStore: ContributionStore
        
    // String variables
    @State private var searchText: String = ""
        
    // Computed var
    private var searchResults: [SavingsPlanModel] {
        if searchText.isEmpty {
            return savingsPlanStore.savingsPlans
        } else {
            return savingsPlanStore.savingsPlans.filter { $0.name?.localizedStandardContains(searchText) ?? false }
        }
    }
    
    // Other
    private let layout: [GridItem] = [GridItem(.flexible(minimum: 40), spacing: 20), GridItem(.flexible(minimum: 40), spacing: 20)]
    
    // MARK: -
    var body: some View {
        ScrollView {
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
                            SavingsPlanRow(savingsPlan: savingsPlan)
                        }
                    )
                    .padding(.bottom)
                }
            }
            .padding()
        } // ScrollView
        .scrollIndicators(.hidden)
        .overlay {
            CustomEmptyView(
                type: (searchResults.isEmpty && !searchText.isEmpty) ? .noResults(searchText) : .empty(.savingsPlan),
                isDisplayed: savingsPlanStore.savingsPlans.isEmpty || (searchResults.isEmpty && !searchText.isEmpty)
            )
        }
        .navigationTitle(Word.Main.savingsPlans)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationButton(
                    route: .sheet,
                    destination: AppDestination.savingsPlan(.create)
                ) {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.text)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onAppear {
            EventService.sendEvent(key: .savingsplanListPage)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsPlansHomeView()
}
