//
//  SavingPlansHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 20/06/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct SavingPlansHomeView: View {
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var savingsPlanRepository: SavingsPlanRepository
    @EnvironmentObject private var contributionRepository: ContributionRepository
        
    // String variables
    @State private var searchText: String = ""
        
    // Computed var
    private var searchResults: [SavingsPlanModel] {
        if searchText.isEmpty {
            return savingsPlanRepository.savingsPlans
        } else {
            return savingsPlanRepository.savingsPlans.filter { $0.name?.localizedStandardContains(searchText) ?? false }
        }
    }
    
    // Other
    private let layout: [GridItem] = [GridItem(.flexible(minimum: 40), spacing: 20), GridItem(.flexible(minimum: 40), spacing: 20)]
    
    //MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            if !savingsPlanRepository.savingsPlans.isEmpty {
                ScrollView(showsIndicators: false) {
                    VStack {
                        LazyVGrid(columns: layout, alignment: .center) {
                            ForEach(searchResults) { savingsPlan in
                                NavigationButton(push: router.pushSavingPlansDetail(savingsPlan: savingsPlan), action: {
                                    Task {
                                        if let savingsPlanID = savingsPlan.id {
                                            await contributionRepository.fetchContributions(savingsplanID: savingsPlanID)
                                        }
                                    }
                                }) {
                                    SavingsPlanRow(savingsPlan: savingsPlan)
                                }
                                .padding(.bottom)
                            }
                        }
                        .padding()
                    }
                } //End ScrollView
            } else {
                ErrorView(
                    searchResultsCount: searchResults.count,
                    searchText: searchText,
                    image: "NoSavingPlan",
                    text: "error_message_savingsplan".localized
                )
            }
        }
        .navigationTitle("word_savingsplans".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationButton(present: router.presentCreateSavingsPlan()) {
                    Image(systemName: "plus")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // End body
} // End struct

//MARK: - Preview
#Preview {
    SavingPlansHomeView()
}
