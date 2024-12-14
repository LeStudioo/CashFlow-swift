//
//  SubcategoryRow.swift
//  TurboBudget
//
//  Created by Théo Sementa on 19/06/2023.
//

import SwiftUI

struct SubcategoryRow: View {
    
    //Custom type
    var subcategory: SubcategoryModel
    @ObservedObject var filter: Filter = sharedFilter
    
    //Computed var
    var stringAmount: String {
        return subcategory.currentMonthExpenses.reduce(0) { $0 + ($1.amount ?? 0) }.toCurrency()
    }
    
    // MARK: -
    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(subcategory.color)
                .frame(width: 45, height: 45)
                .overlay {
                    CustomOrSystemImage(
                        systemImage: subcategory.icon,
                        size: 18
                    )
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subcategory.name)
                    .font(.semiBoldCustom(size: 20))
                    .foregroundStyle(Color(uiColor: .label))
                    .lineLimit(1)
                
                Text(stringAmount)
                    .font(.semiBoldText18())
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color(uiColor: .label))
                .font(.system(size: 14, weight: .semibold, design: .rounded))
        }
        .padding()
        .background(Color.colorCell)
        .cornerRadius(15)
    } // End body
} // End struct

//MARK: - Preview
#Preview {
    SubcategoryRow(subcategory: .mock)
}
