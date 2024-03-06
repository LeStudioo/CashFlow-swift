//
//  SubcategoryRow.swift
//  TurboBudget
//
//  Created by Théo Sementa on 19/06/2023.
//

import SwiftUI

struct SubcategoryRow: View {
    
    //Custom type
    var subcategory: PredefinedSubcategory
    @ObservedObject var filter: Filter = sharedFilter
    
    //Environnements
    
    //State or Binding String
    
    //State or Binding Int, Float and Double
    
    //State or Binding Bool
    
    //State or Binding Date
    
    //Enum
    
    //Computed var
    var stringAmount: String {
        if !filter.automation && !filter.total {
            return subcategory.expensesTransactionsAmountForSelectedDate(filter: filter).currency
        } else if filter.automation && !filter.total {
            return subcategory.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date).currency
        } else if !filter.automation && filter.total {
            return subcategory.amountTotalOfExpenses.currency
        } else if filter.automation && filter.total {
            return subcategory.amountTotalOfExpensesAutomations.currency
        }
        return ""
    }
    
    //MARK: - Body
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundStyle(subcategory.category.color)
                    .frame(width: 45, height: 45)
                
                if let _ = UIImage(systemName: subcategory.icon) {
                    Image(systemName: subcategory.icon)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                } else {
                    Image("\(subcategory.icon)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subcategory.title)
                    .font(.semiBoldCustom(size: 20))
                    .foregroundStyle(Color(uiColor: .label))
                    .lineLimit(1)
                
                Text(stringAmount)
                    .font(.semiBoldText18())
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if subcategory.transactions.count != 0 && stringAmount != 0.currency {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(uiColor: .label))
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
        }
        .padding()
        .background(Color.colorCell)
        .cornerRadius(15)
    }//END body
    
    //MARK: Fonctions
    
}//END struct

//MARK: - Preview
#Preview {
    SubcategoryRow(subcategory: subCategory1Category1)
}
