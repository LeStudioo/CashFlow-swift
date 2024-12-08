//
//  DetailOfCategory.swift
//  CashFlow
//
//  Created by KaayZenn on 25/09/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct DetailOfCategory: View {
    
    //Builder
    var category: CategoryModel

    //Environnement
    @Environment(\.colorScheme) private var colorScheme

    //MARK: - Body
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: -1) {
                Text(category.name)
                    .font(.mediumCustom(size: 22))
                
                if category.amountTotalOfExpenses != 0 {
                    Text("word_expenses".localized + " : " + category.amountTotalOfExpenses.toCurrency())
                        .lineLimit(1)
                        .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                        .font(.semiBoldSmall())
                }
                if category.amountTotalOfIncomes != 0 {
                    Text("word_incomes".localized + " : " + category.amountTotalOfIncomes.toCurrency())
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
    DetailOfCategory(category: .mock)
}
