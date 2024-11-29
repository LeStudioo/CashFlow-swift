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

    //Custom type
    var contribution: ContributionModel

    //Environnements
    @Environment(\.colorScheme) private var colorScheme

    //State or Binding Bool
    @State private var isDeleting: Bool = false
    @State private var cancelDeleting: Bool = false
    
    //MARK: - 
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
                isDeleting.toggle()
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
            .onChange(of: cancelDeleting) { _ in
                context.state.wrappedValue = .closed
            }
        })
        .swipeActionsStyle(.cascade)
        .swipeActionCornerRadius(15)
        .swipeMinimumDistance(30)
        .padding(.horizontal, 12)
        .padding(.vertical, 2)
        .alert("contribution_cell_delete".localized, isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { cancelDeleting.toggle(); return }, label: { Text("word_cancel".localized) })
//            Button(role: .destructive, action: { withAnimation { deleteContribution() } }, label: { Text("word_delete".localized) })
        }, message: {
            Text("contribution_cell_delete_desc".localized)
        })
    }//END body

    //MARK: Fonctions
    // TODO: DELETE
//    func deleteContribution() {
//        DispatchQueue.main.async {
//            if let account = contribution.contributionToSavingPlan?.savingPlansToAccount {
//                account.balance = contribution.amount < 0 ? account.balance + contribution.amount : account.balance + contribution.amount
//            }
//            
//            if let savingPlan = contribution.contributionToSavingPlan {
//                savingPlan.actualAmount = contribution.amount < 0 ? savingPlan.actualAmount - contribution.amount : savingPlan.actualAmount - contribution.amount
//            }
//            
//            viewContext.delete(contribution)
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            persistenceController.saveContext()
//        }
//    }
}//END struct

//MARK: - Preview
#Preview {
    ContributionRow(contribution: .mockContribution)
}
