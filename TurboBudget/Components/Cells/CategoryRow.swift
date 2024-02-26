//
//  CategoryRow.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//

import SwiftUI

struct CategoryRow: View {
    
    // Builder
    @ObservedObject var category: PredefinedCategory
    var showChevron: Bool?
    
    // Custom
    @ObservedObject var filter: Filter = sharedFilter
	
	// Computed variables
    var stringAmount: String {
        if !filter.automation && !filter.total {
            if category.idUnique == "PREDEFCAT0" {
                return category.incomesTransactionsAmountForSelectedDate(filter: filter).currency
            } else {
                return category.expensesTransactionsAmountForSelectedDate(filter: filter).currency
            }
        } else if filter.automation && !filter.total {
            if category.idUnique == "PREDEFCAT0" {
                return category.incomesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date).currency
            } else {
                return category.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date).currency
            }
        } else if !filter.automation && filter.total {
            if category.idUnique == "PREDEFCAT0" {
                return category.amountTotalOfIncomes.currency
            } else {
                return category.amountTotalOfExpenses.currency
            }
        } else if filter.automation && filter.total {
            if category.idUnique == "PREDEFCAT0" {
                return category.amountTotalOfIncomesAutomations.currency
            } else {
                return category.amountTotalOfExpensesAutomations.currency
            }
        }
        return ""
    }

    // MARK: - body
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundColor(category.color)
                    .frame(width: 45, height: 45)
                Image(systemName: category.icon)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
            }
            .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.title)
                    .font(.semiBoldCustom(size: 20))
                    .lineLimit(1)
                
                Text(stringAmount)
                    .font(.semiBoldText18())
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if let showChevron {
                if (category.subcategories.count != 0 || category.transactions.count != 0) && showChevron {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.colorLabel)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
            }
        }
        .padding()
        .background(Color.colorCell)
        .cornerRadius(15)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CategoryRow(category: categoryPredefined2)
}
