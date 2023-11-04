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
    
    //Custom type
    @Binding var account: Account?
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    
    //State or Binding String
    @State private var searchText: String = ""
    
    //State or Binding Int, Float and Double
    
    //State or Binding Bool
    
    //State or Binding Date
    
    //Enum
    
    //Computed var
    
    var searchResults: [SavingPlan] {
        if let account {
            if searchText.isEmpty {
                return account.savingPlansArchived
            } else {
                return account.savingPlansArchived.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            }
        } else { return [] }
    }
    
    //Other
    private let layout: [GridItem] = [GridItem(.flexible(minimum: 40), spacing: 20), GridItem(.flexible(minimum: 40), spacing: 20)]
    
    //Binding update
    @Binding var update: Bool
    
    //MARK: - Body
    var body: some View {
        if let account {
            VStack {
                if searchResults.count != 0 {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            LazyVGrid(columns: layout, alignment: .center) {
                                ForEach(searchResults) { savingPlan in
                                    NavigationLink(destination: {
                                        SavingPlanDetailView(savingPlan: savingPlan, update: $update)
                                    }, label: {
                                        CellSavingPlanView(savingPlan: savingPlan, update: $update)
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
            .padding(update ? 0 : 0)
            .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
            .navigationTitle(NSLocalizedString("word_archived_savingsplans", comment: ""))
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }, label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.colorLabel)
                    })
                }
            }
            .searchable(text: $searchText.animation(), prompt: NSLocalizedString("word_search", comment: ""))
            .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
            .onDisappear { update.toggle() }
            .onChange(of: account.savingPlansArchived) { newValue in
                if newValue.count == 0 { dismiss() }
            }
        }
    }//END body
}//END struct

//MARK: - Preview
struct ArchivedSavingPlansView_Previews: PreviewProvider {
    
    @State static private var previewUpdate: Bool = false
    @State static var previewAccount: Account? = previewAccount1()
    
    static var previews: some View {
        ArchivedSavingPlansView(account: $previewAccount, update: $previewUpdate)
    }
}
