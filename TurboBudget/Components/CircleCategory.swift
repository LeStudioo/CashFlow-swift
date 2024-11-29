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
    var transaction: TransactionModel? = nil
    
    @EnvironmentObject private var accountRepository: AccountRepository
    
    // MARK: -
    var body: some View {
        Circle()
            .foregroundStyle(Color.background)
            .frame(width: 50)
            .overlay {
                if let category, let subcategory {
                    Circle()
                        .foregroundStyle(category.color)
                        .shadow(radius: 4, y: 4)
                        .frame(width: 34)
                    
                    CustomOrSystemImage(
                        systemImage: subcategory.icon,
                        size: 14
                    )
                } else if let category, subcategory == nil {
                    Circle()
                        .foregroundStyle(category.color)
                        .shadow(radius: 4, y: 4)
                        .frame(width: 34)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(uiColor: .systemBackground))
                } else if let transaction, transaction.type == .transfer, let selectedAccount = accountRepository.selectedAccount, let accountID = selectedAccount.id {
                    Circle()
                        .foregroundStyle(accountID == transaction.senderAccountID ? .error400 : .primary500)
                        .shadow(radius: 4, y: 4)
                        .frame(width: 34)
                    
                    Text(Locale.current.currencySymbol ?? "$")
                        .foregroundStyle(Color(uiColor: .systemBackground))
                } else {
                    Circle()
                        .foregroundStyle(.gray)
                        .shadow(radius: 4, y: 4)
                        .frame(width: 34)
                    
                    Text(Locale.current.currencySymbol ?? "$")
                        .foregroundStyle(Color(uiColor: .systemBackground))
                }
            }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CircleCategory()
}
