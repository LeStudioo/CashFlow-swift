//
//  CircleCategory.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import SwiftUI

struct CircleCategory: View {
    
    // Builder
    var category: CategoryModel?
    var subcategory: SubcategoryModel?
    var transaction: TransactionModel?
    
    @EnvironmentObject private var accountStore: AccountStore
    
    // MARK: -
    var body: some View {
        ZStack {
            if let category, let subcategory {
                Circle()
                    .foregroundStyle(category.color)
                    .frame(width: 36)

                Image(subcategory.icon) // TODO: Verify
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.white)
                    .frame(width: 14, height: 14)
            } else if let category, subcategory == nil {
                Circle()
                    .foregroundStyle(category.color)
                    .frame(width: 36)
                
                Image(category.icon) // TODO: Verify
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.white)
                    .frame(width: 14, height: 14)
            } else if let transaction, transaction.type == .transfer,
                      let selectedAccount = accountStore.selectedAccount,
                      let accountID = selectedAccount._id {
                let isSender = accountID == transaction.senderAccount?._id
                Circle()
                    .foregroundStyle(isSender ? .error400 : .primary500)
                    .frame(width: 36)
                
                Image(systemName: isSender ? "antenna.radiowaves.left.and.right" : "tray.fill")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(uiColor: .systemBackground))
            } else {
                Circle()
                    .foregroundStyle(.gray)
                    .frame(width: 36)
                
                Text(UserCurrency.symbol)
                    .foregroundStyle(Color(uiColor: .systemBackground))
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CircleCategory()
}
