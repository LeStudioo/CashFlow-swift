//
//  CategoriesHomeViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 04/07/2024.
//

import Foundation

struct CategoryAmount: Identifiable {
    let id: UUID
    let categoryId: Int?
    let amount: Double
    
    init(categoryId: Int?, amount: Double) {
        self.id = UUID()
        self.categoryId = categoryId
        self.amount = amount
    }
}

final class CategoriesHomeViewModel: ObservableObject {
    
    let categories = CategoryStore.shared.categories
        
    @Published var categoryAmounts: [Int?: CategoryAmount] = [:]
    @Published var searchText: String = ""
}

extension CategoriesHomeViewModel {
    
    var isChartDisplayed: Bool {
        let transactionStore: TransactionStore = .shared
        return transactionStore.getExpenses(in: .now).isEmpty && transactionStore.getIncomes(in: .now).isEmpty
    }
    
    var categoriesFiltered: [CategoryModel] {
        return categories.searchFor(searchText)
    }
    
    func calculateAllAmounts(for date: Date) {
        let transactionStore: TransactionStore = .shared
        let groupedTransactions = Dictionary(grouping: transactionStore.transactions) { $0.categoryID }
        
        var newAmounts: [Int?: CategoryAmount] = [:]
        
        for (categoryId, transactions) in groupedTransactions {
            let totalAmount = transactions
                .filter { transaction in
                    let startOfMonth = date.startOfMonth
                    let endOfMonth = date.endOfMonth
                    return transaction.date >= startOfMonth && transaction.date <= endOfMonth
                }
                .reduce(0.0) { sum, transaction in
                    sum + (transaction.amount ?? 0)
                }
            
            newAmounts[categoryId] = CategoryAmount(categoryId: categoryId, amount: totalAmount)
        }
        
        DispatchQueue.main.async {
            self.categoryAmounts = newAmounts
        }
    }
    
}
