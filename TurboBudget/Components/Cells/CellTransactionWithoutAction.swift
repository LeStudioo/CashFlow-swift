//
//  CellTransactionWithoutAction.swift
//  CashFlow
//
//  Created by Théo Sementa on 05/07/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct CellTransactionWithoutAction: View {

    //Custom type
    var transaction: Transaction
    
    //Environnements
    @Environment(\.colorScheme) private var colorScheme

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool
    @Binding var update: Bool

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
                Text(transaction.amount < 0
                     ? (transaction.comeFromAuto ? NSLocalizedString("word_automation_expense", comment: "") : NSLocalizedString("word_expense", comment: ""))
                     : (transaction.comeFromAuto ? NSLocalizedString("word_automation_income", comment: "") : NSLocalizedString("word_income", comment: "")))
                    .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                    .font(Font.mediumSmall())
                Text(transaction.title)
                    .font(.semiBoldText18())
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
        .padding(update ? 0 : 0)
    }//END body

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct TransactionCellWithoutAction_Previews: PreviewProvider {
    
    @State static var previewUpdate: Bool = false
    
    static var previews: some View {
        CellTransactionWithoutAction(transaction: previewTransaction1(), update: $previewUpdate)
    }
}
