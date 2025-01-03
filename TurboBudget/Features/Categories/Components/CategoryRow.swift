//
//  CategoryRow.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//

import SwiftUI

struct CategoryRow: View {
    
    // Builder
    var category: CategoryModel
    var selectedDate: Date
    var amount: String
    
    // Custom
    @ObservedObject var filter: Filter = sharedFilter
    @EnvironmentObject private var transactionStore: TransactionStore
        
    // MARK: -
    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(category.color)
                .frame(width: 45, height: 45)
                .overlay {
                    Image(systemName: category.icon)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.semiBoldCustom(size: 20))
                    .lineLimit(1)
                
                Text(amount)
                    .font(.semiBoldText18())
                    .animation(.smooth, value: amount)
                    .contentTransition(.numericText())
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.text)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
        }
        .padding()
        .padding(.trailing, 8)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.background100)
        }
//        .onAppear {
//            calculateAmount()
//        }
//        .onChange(of: selectedDate) { _ in
//            calculateAmount()
//        }
//        .onChange(of: transactionStore.transactions) { _ in
//            calculateAmount()
//        }
    } // body
    
//    private func calculateAmount() {
//        if category.isRevenue {
//            amount = transactionStore.getIncomes(for: category, in: selectedDate)
//                .compactMap(\.amount)
//                .reduce(0, +)
//                .toCurrency()
//        } else {
//            amount = transactionStore.getExpenses(for: category, in: selectedDate)
//                .compactMap(\.amount)
//                .reduce(0, +)
//                .toCurrency()
//        }
//    }
    
} // struct

// MARK: - Preview
#Preview {
    CategoryRow(category: .mock, selectedDate: .now, amount: "")
}
