//
//  CellTransactionForAutomationView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import SwipeActions

struct CellTransactionForAutomationView: View {

    //Custom type
    var transaction: Transaction

    //Environnements
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool
    @Binding var update: Bool
    @State private var isDeleting: Bool = false
    @State private var cancelDeleting: Bool = false

	//Enum
	
	//Computed var
    var category: PredefinedCategory? {
        return PredefinedCategoryManager().categoryByUniqueID(idUnique: transaction.predefCategoryID)
    }
    
    var subcategory: PredefinedSubcategory? {
        if let category {
            return PredefinedSubcategoryManager().subcategoryByUniqueID(subcategories: category.subcategories, idUnique: transaction.predefSubcategoryID)
        } else {
            return nil
        }
    }

    //MARK: - Body
    var body: some View {
        SwipeView(label: {
            HStack {
                Circle()
                    .foregroundColor(.color2Apple)
                    .frame(width: 50)
                    .overlay {
                        if let category, let subcategory {
                            Circle()
                                .foregroundColor(category.color)
                                .shadow(radius: 4, y: 4)
                                .frame(width: 34)
                            
                            Image(systemName: subcategory.icon)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.colorLabelInverse)
                            
                        } else if let category, subcategory == nil {
                            Circle()
                                .foregroundColor(category.color)
                                .shadow(radius: 4, y: 4)
                                .frame(width: 34)
                            
                            Image(systemName: category.icon)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.colorLabelInverse)
                        } else {
                            Circle()
                                .foregroundColor(transaction.amount < 0 ? .error400 : .primary500)
                                .shadow(radius: 4, y: 4)
                                .frame(width: 34)
                            
                            Text(Locale.current.currencySymbol ?? "$")
                                .foregroundColor(.colorLabelInverse)
                        }
                    }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(transaction.amount < 0 ? NSLocalizedString("word_automation_expense", comment: "") : NSLocalizedString("word_automation_income", comment: ""))
                        .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                        .font(Font.mediumSmall())
                    Text(transaction.title)
                        .font(.semiBoldText18())
                        .foregroundColor(.colorLabel)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text(transaction.amount.currency)
                        .font(.semiBoldText16())
                        .foregroundColor(transaction.amount < 0 ? .error400 : .primary500)
                        .lineLimit(1)
                    Text(transaction.date.formatted(date: .numeric, time: .omitted))
                        .font(Font.mediumSmall())
                        .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                        .lineLimit(1)
                }
            }
            .padding(12)
            .background(Color.colorCell)
            .cornerRadius(15)
            
        }, trailingActions: { context in
            SwipeAction(action: {
                isDeleting.toggle()
            }, label: { _ in
                VStack(spacing: 5) {
                    Image(systemName: "trash")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    Text(NSLocalizedString("word_DELETE", comment: ""))
                        .font(.semiBoldCustom(size: 10))
                }
                .foregroundColor(.colorLabelInverse)
            }, background: { _ in
                Rectangle()
                    .foregroundColor(.error400)
            })
            .onChange(of: cancelDeleting) { _ in
                context.state.wrappedValue = .closed
            }
        })
        .swipeActionsStyle(.cascade)
        .swipeActionWidth(90)
        .swipeActionCornerRadius(15)
        .swipeMinimumDistance(30)
        .padding(.vertical, 4)
        .padding(.horizontal)
        .padding(update ? 0 : 0)
        .alert(NSLocalizedString("transaction_cell_delete_auto", comment: ""), isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { cancelDeleting.toggle(); return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
            Button(role: .destructive, action: { withAnimation { deleteTransactionWithAutomation() } }, label: { Text(NSLocalizedString("word_delete", comment: "")) })
        }, message: {
            Text(NSLocalizedString("transaction_cell_delete_auto_desc", comment: ""))
        })
    }//END body

    //MARK: Fonctions
    func deleteTransactionWithAutomation() {
        if let auto = transaction.transactionToAutomation {
            NotificationManager().deleteNotification(transaction: transaction, Automation: auto)
        }
        DispatchQueue.main.async {
            if let automation = transaction.transactionToAutomation {
                viewContext.delete(transaction)
                viewContext.delete(automation)
                update.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    persistenceController.saveContext()
                }
            }
        }
    }
    
}//END struct

//MARK: - Preview
struct TransactionCellForSubscritpionView_Previews: PreviewProvider {
    
    @State static var previewUpdate: Bool = false
    
    static var previews: some View {
        CellTransactionForAutomationView(transaction: previewTransaction1(), update: $previewUpdate)
    }
}
