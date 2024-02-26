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
                
                if category.amountTotalOfExpenses != 0 {
                    Text("word_expenses".localized + " : " + category.amountTotalOfExpenses.currency)
                        .lineLimit(1)
                        .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                        .font(.semiBoldSmall())
                }
                if category.amountTotalOfIncomes != 0 {
                    Text("word_incomes".localized + " : " + category.amountTotalOfIncomes.currency)
                        .lineLimit(1)
                        .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                        .font(.semiBoldSmall())
                }
            }
            
            Spacer()
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(category.color)
                .overlay {
                    Image(systemName: category.icon)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.colorLabelInverse)
                }
        }
        .padding([.horizontal, .top])
    }//END body
}//END struct

//MARK: - Preview
#Preview {
    DetailOfCategory(category: categoryPredefined1)
}
