//
//  DetailOfCategoryForArchivedTransaction.swift
//  CashFlow
//
//  Created by KaayZenn on 17/10/2023.
//

import SwiftUI

struct DetailOfCategoryForArchivedTransaction: View {
    
    // Builder
    var category: CategoryModel

    // MARK: -
    var body: some View {
        HStack {
//            VStack(alignment: .leading, spacing: -1) {
//                Text(category.title)
//                    .font(.mediumCustom(size: 22))
//                
//                if category.amountTotalOfArchivedTransactionsExpenses != 0 {
//                    Text("word_expenses".localized + " : " + category.amountTotalOfArchivedTransactionsExpenses.toCurrency())
//                        .lineLimit(1)
//                        .foregroundStyle(Color.customGray)
//                        .font(.semiBoldSmall())
//                }
//                if category.amountTotalOfArchivedTransactionsIncomes != 0 {
//                    Text("word_incomes".localized + " : " + category.amountTotalOfArchivedTransactionsIncomes.toCurrency())
//                        .lineLimit(1)
//                        .foregroundStyle(Color.customGray)
//                        .font(.semiBoldSmall())
//                }
//            }
            
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
    } // body
} // struct

// MARK: - Preview
#Preview {
    DetailOfCategoryForArchivedTransaction(category: .mock)
}
