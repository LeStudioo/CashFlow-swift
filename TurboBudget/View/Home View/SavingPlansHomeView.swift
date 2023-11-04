//
//  SavingPlansHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 20/06/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct SavingPlansHomeView: View {
    
    //Custom type
    @Binding var account: Account?
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    
    //State or Binding String
    @State private var searchText: String = ""
    
    //State or Binding Int, Float and Double
    
    //State or Binding Bool
    @Binding var update: Bool
    @State private var showAddSavingPlan: Bool = false
    
    //Enum
    
    //Computed var
    private var searchResults: [SavingPlan] {
        if let account {
            if searchText.isEmpty {
                return account.savingPlans
            } else {
                return account.savingPlans.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            }
        } else { return [] }
    }
    
    //Other
    private let layout: [GridItem] = [GridItem(.flexible(minimum: 40), spacing: 20), GridItem(.flexible(minimum: 40), spacing: 20)]
    
    //MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            if let account, account.savingPlans.count != 0 {
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
            } else {
                ErrorView(
                    searchResultsCount: searchResults.count,
                    searchText: searchText,
                    image: "NoSavingPlan",
                    text: NSLocalizedString("error_message_savingsplan", comment: "")
                )
            }
        }
        .navigationTitle(NSLocalizedString("word_savingsplans", comment: ""))
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .searchable(text: $searchText.animation(), prompt: NSLocalizedString("word_search", comment: ""))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.colorLabel)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddSavingPlan.toggle() }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.colorLabel)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
        }
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showAddSavingPlan, onDismiss: { update.toggle() }) { AddSavingPlanView(account: $account) }
    }//END body
}//END struct

//MARK: - Preview
struct SavingPlansHomeView_Previews: PreviewProvider {
    
    @State static var previewAccount: Account? = previewAccount1()
    @State static var preveiwUpdate: Bool = false
    
    static var previews: some View {
        SavingPlansHomeView(account: $previewAccount, update: $preveiwUpdate)
    }
}
