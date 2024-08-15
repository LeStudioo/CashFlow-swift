//
//  ArchivedSavingPlansView.swift
//  CashFlow
//
//  Created by KaayZenn on 02/08/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

struct ArchivedSavingPlansView: View {
    
    // Builder
    @ObservedObject var account: Account
    
    // Environement
    @EnvironmentObject private var router: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    // String variables
    @State private var searchText: String = ""

    // Computed var
    var searchResults: [SavingPlan] {
        if searchText.isEmpty {
            return account.savingPlansArchived
        } else {
            return account.savingPlansArchived.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // Other
    private let layout: [GridItem] = [GridItem(.flexible(minimum: 40), spacing: 20), GridItem(.flexible(minimum: 40), spacing: 20)]
    
    // MARK: - body
    var body: some View {
        VStack {
            if searchResults.count != 0 {
                ScrollView(showsIndicators: false) {
                    VStack {
                        LazyVGrid(columns: layout, alignment: .center) {
                            ForEach(searchResults) { savingPlan in
                                Button(action: {
                                    router.pushSavingPlansDetail(savingPlan: savingPlan)
                                }, label: {
                                    SavingsPlanRow(savingPlan: savingPlan)
                                })
                                .padding(.bottom)
                            }
                        }
                        .padding()
                    }
                } //End ScrollView
            } else { //SearchResult == 0
                ErrorView(
                    searchResultsCount: searchResults.count,
                    searchText: searchText,
                    image: "",
                    text: ""
                )
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationTitle("word_archived_savingsplans".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
        }
        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onChange(of: account.savingPlansArchived) { newValue in
            if newValue.count == 0 { dismiss() }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    ArchivedSavingPlansView(account: Account.preview)
}
