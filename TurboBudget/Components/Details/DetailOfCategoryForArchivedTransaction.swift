//
//  DetailOfCategoryForArchivedTransaction.swift
//  CashFlow
//
//  Created by KaayZenn on 17/10/2023.
//

import SwiftUI

struct DetailOfCategoryForArchivedTransaction: View {
    
    //Builder
    var category: PredefinedCategory

    //Custom type

    //Environnement
    @Environment(\.colorScheme) private var colorScheme

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool

    //Enum
    
    //Computed var

    //MARK: - Body
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: -1) {
                Text(category.title)
                    .font(.mediumCustom(size: 22))
                
                if category.amountTotalOfArchivedTransactionsExpenses != 0 {
                    Text("word_expenses".localized + " : " + category.amountTotalOfArchivedTransactionsExpenses.currency)
                        .lineLimit(1)
                        .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                        .font(.semiBoldSmall())
                }
                if category.amountTotalOfArchivedTransactionsIncomes != 0 {
                    Text("word_incomes".localized + " : " + category.amountTotalOfArchivedTransactionsIncomes.currency)
                        .lineLimit(1)
                        .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                        .font(.semiBoldSmall())
                }
            }
            
            Spacer()
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle(category.color)
                .overlay {
                    Image(systemName: category.icon)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(uiColor: .systemBackground))
                }
        }
        .padding([.horizontal, .top])
    }//END body
}//END struct

//MARK: - Preview
#Preview {
    DetailOfCategoryForArchivedTransaction(category: categoryPredefined1)
}
