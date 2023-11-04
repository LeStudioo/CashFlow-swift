//
//  BudgetsTransactionsView.swift
//  CashFlow
//
//  Created by KaayZenn on 17/08/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

struct BudgetsTransactionsView: View {

    //Custom type
    var subcategory: PredefinedSubcategory

    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    //State or Binding String
    @State private var searchText: String = ""

    //State or Binding Int, Float and Double
    @State private var newAmount: Double = 0.0
    
    //State or Binding Bool
    @State private var ascendingOrder: Bool = false
    @State private var showEditMaxAmount: Bool = false
    @State private var showDeleteBudget: Bool = false

	//Enum
	
	//Computed var
    var searchResults: [Transaction] {
        var array: [Transaction] = []
        if searchText.isEmpty {
            if ascendingOrder {
                array = subcategory.transactions.filter { $0.amount < 0 }.sorted { $0.amount < $1.amount }.reversed()
            } else {
                array = subcategory.transactions.filter { $0.amount < 0 }.sorted { $0.amount < $1.amount }
            }
        } else { array = subcategory.transactions.filter { $0.title.localizedCaseInsensitiveContains(searchText) } }
        
        return array.filter { $0.date > Date().startOfMonth && $0.date < Date().endOfMonth }
    }
    
    //Other
    var numberFormatter: NumberFormatter {
        let numFor = NumberFormatter()
        numFor.numberStyle = .decimal
        numFor.zeroSymbol = ""
        return numFor
    }
    
    //Binding update
    @Binding var update: Bool

    //MARK: - Body
    var body: some View {
        VStack {
            if subcategory.transactions.count != 0 && searchResults.count != 0{
                ScrollView(showsIndicators: false) {
                    detailForExpenses()
                    ForEach(searchResults) { transaction in
                        NavigationLink(destination: {
                            TransactionDetailView(transaction: transaction, update: $update)
                        }, label: {
                            CellTransactionView(transaction: transaction, update: $update)
                        })
                    }
                }
            } else { // No Transaction
                ErrorView(
                    searchResultsCount: searchResults.count,
                    searchText: searchText,
                    image: "NoTransaction",
                    text: NSLocalizedString("budgets_transactions_no_transaction", comment: "")
                )
            }
        }
        .padding(update ? 0 : 0)
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
        .navigationTitle(NSLocalizedString("word_transactions", comment: ""))
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .alert(NSLocalizedString("budgets_transactions_editing", comment: ""), isPresented: $showEditMaxAmount, actions: {
            TextField(NSLocalizedString("budgets_transactions_amount", comment: ""), value: $newAmount, formatter: numberFormatter)
            Button(role: .cancel, action: { return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
            Button(action: {
                if newAmount != 0 {
                    if let budget = subcategory.budget {
                        budget.amount = newAmount
                        persistenceController.saveContext()
                        update.toggle()
                    }
                }
            }, label: { Text(NSLocalizedString("budgets_transactions_edit", comment: "")) })
        }, message: { Text(NSLocalizedString("budgets_transactions_edit_desc", comment: "")) })
        .alert(NSLocalizedString("budgets_transactions_delete_budget", comment: ""), isPresented: $showDeleteBudget, actions: {
            Button(role: .cancel, action: { return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
            Button(role: .destructive, action: {
                DispatchQueue.main.async {
                    if let budget = subcategory.budget {
                        dismiss()
                        viewContext.delete(budget)
                        update.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            persistenceController.saveContext()
                            update.toggle()
                        }
                    }
                }
            }, label: { Text(NSLocalizedString("word_delete", comment: "")) })
        }, message: {
            Text(NSLocalizedString("budgets_transactions_delete_budget_desc", comment: ""))
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.colorLabel)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button(action: { showEditMaxAmount.toggle() }, label: { Label(NSLocalizedString("budgets_transactions_button_edit", comment: ""), systemImage: "pencil") })
                    Button(role: .destructive, action: { showDeleteBudget.toggle() }, label: { Label(NSLocalizedString("word_delete", comment: ""), systemImage: "trash") })
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.colorLabel)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
        }
        .searchable(text: $searchText.animation(), prompt: NSLocalizedString("word_search", comment: ""))
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
        .onDisappear { update.toggle() }
    }//END body
    
    //MARK: ViewBuilder
    @ViewBuilder
    func detailForExpenses() -> some View {
        HStack {
            HStack(alignment: .bottom) {
                Text(searchResults.map({ $0.amount }).reduce(0, -).currency)
                    .font(.mediumCustom(size: 22))
                Spacer()
                Button(action: { withAnimation { ascendingOrder.toggle() } }, label: {
                    HStack {
                        Text(NSLocalizedString("word_expenses", comment: ""))
                        Image(systemName: "arrow.up")
                            .rotationEffect(.degrees(ascendingOrder ? 180 : 0))
                    }
                })
                .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                .font(.semiBoldSmall())
            }
            .font(.mediumCustom(size: 22))
            
            Spacer()
        }
        .padding([.horizontal, .top])
    }

    //MARK: Fonctions

}//END struct

//MARK: - Preview
#Preview {
    BudgetsTransactionsView(subcategory: subCategory1Category1, update: Binding.constant(false))
}
