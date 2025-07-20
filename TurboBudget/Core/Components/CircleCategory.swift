//
//  CircleCategory.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import SwiftUI
import CoreModule

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

                IconSVG(icon: subcategory.icon, value: .medium)
            } else if let category, subcategory == nil {
                Circle()
                    .foregroundStyle(category.color)
                    .frame(width: 36)
                
                IconSVG(icon: category.icon, value: .medium)
            } else if let transaction, transaction.type == .transfer,
                      let selectedAccount = accountStore.selectedAccount,
                      let accountID = selectedAccount._id {
                let isSender = accountID == transaction.senderAccount?._id
                Circle()
                    .foregroundStyle(isSender ? .error400 : .primary500)
                    .frame(width: 36)
                
                IconSVG(icon: isSender ? .iconSend : .iconInbox, value: .medium)
            } else {
                Circle()
                    .foregroundStyle(.gray)
                    .frame(width: 36)
                
                Text(UserCurrency.symbol)
                    .foregroundStyle(Color(uiColor: .systemBackground))
            }
        }
        .foregroundStyle(Color.white)
    } // body
} // struct

// MARK: - Preview
#Preview {
    CircleCategory()
}
