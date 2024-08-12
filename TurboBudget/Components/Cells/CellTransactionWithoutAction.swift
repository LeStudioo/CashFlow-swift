//
//  CellTransactionWithoutAction.swift
//  CashFlow
//
//  Created by Théo Sementa on 05/07/2023.
//
// Localizations 01/10/2023
// Refactor 17/02/2024

import SwiftUI

struct CellTransactionWithoutAction: View {

    // Builder
    @ObservedObject var transaction: Transaction
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme

	//Computed var
    var category: PredefinedCategory? {
        return PredefinedCategory.findByID(transaction.predefCategoryID)
    }
    
    var subcategory: PredefinedSubcategory? {
        if let category {
            return category.subcategories.findByID(transaction.predefSubcategoryID)
        } else { return nil }
    }
    
    // MARK: - body
    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(.color2Apple)
                .frame(width: 50)
                .overlay {
                    if let category, let subcategory {
                        Circle()
                            .foregroundStyle(category.color)
                            .shadow(radius: 4, y: 4)
                            .frame(width: 34)
                        
                        Image(systemName: subcategory.icon)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(uiColor: .systemBackground))
                        
                    } else if let category, subcategory == nil {
                        Circle()
                            .foregroundStyle(category.color)
                            .shadow(radius: 4, y: 4)
                            .frame(width: 34)
                        
                        Image(systemName: category.icon)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(uiColor: .systemBackground))
                    } else {
                        Circle()
                            .foregroundStyle(transaction.amount < 0 ? .error400 : .primary500)
                            .shadow(radius: 4, y: 4)
                            .frame(width: 34)
                        
                        Text(Locale.current.currencySymbol ?? "$")
                            .foregroundStyle(Color(uiColor: .systemBackground))
                    }
                }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(transaction.amount < 0
                     ? (transaction.comeFromAuto ? "word_automation_expense".localized : "word_expense".localized)
                     : (transaction.comeFromAuto ? "word_automation_income".localized : "word_income".localized))
                    .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                    .font(Font.mediumSmall())
                Text(transaction.title)
                    .font(.semiBoldText18())
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text(transaction.amount.currency)
                    .font(.semiBoldText16())
                    .foregroundStyle(transaction.amount < 0 ? .error400 : .primary500)
                    .lineLimit(1)
                Text(transaction.date.formatted(date: .numeric, time: .omitted))
                    .font(Font.mediumSmall())
                    .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .background(Color.colorCell)
        .cornerRadius(15)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CellTransactionWithoutAction(transaction: Transaction.preview1)
}
