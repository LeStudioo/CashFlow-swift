//
//  ListPagination.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI

struct ListPagination<Item: Identifiable, Content: View>: View {
    
    private var items: [Item]
    var content: (_ item: Item) -> Content
    
    var pagination: ((() -> Void)?) -> Void
    @State var isLoading = false
    private var offset: Int
    
    init (items: [Item], offset: Int = 5,
                 pagination: @escaping (_ completion: (() -> Void)?) -> Void,
                 @ViewBuilder content: @escaping (_ item: Item) -> Content) {
        self.items =  items
        self.content = content
        self.pagination = pagination
        self.offset = offset
    }
    
    // MARK: -
    var body: some View {
        List {
            ForEach(items.indices, id: \.self) { index in
                VStack {
                    self.content(self.items[index])
                    
                    if self.isLoading && self.isLastItem(index: index) {
                        HStack(alignment: .center) {
                            ProgressView()
                        }
                    }
                }.onAppear {
                    self.itemAppears(at: index)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private func isLastItem(index: Int) -> Bool {
      index == (items.count - 1)
    }

    private func isOffsetReached(at index: Int) -> Bool {
      index == (items.count - offset)
    }

    private func itemAppears(at index: Int) {
      if isOffsetReached(at: index) {
        isLoading = true

        pagination {
          self.isLoading = false
        }
      }
    }
}


//ListPagination(
//    items: transactionRepository.transactions,
//    offset: 8) { completion in
//        Task {
//            if let selectedAccount = accountRepository.selectedAccount, let accountID = selectedAccount.id {
//                await transactionRepository.fetchTransactionsWithPagination(accountID: accountID)
//            }
//        }
//    } content: { transaction in
//        NavigationButton(push: router.pushTransactionDetail(transaction: transaction)) {
//            TransactionRow(transaction: transaction)
//                .padding(.horizontal)
//        }
//    }
