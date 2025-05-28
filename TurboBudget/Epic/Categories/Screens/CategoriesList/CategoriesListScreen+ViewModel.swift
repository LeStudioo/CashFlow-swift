//
//  CategoriesHomeViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 04/07/2024.
//

import Foundation

extension CategoriesListScreen {
    
    final class ViewModel: ObservableObject {
        let categories = CategoryStore.shared.categories
            
        @Published var categoryAmounts: [Int?: CategoryAmount] = [:]
        @Published var searchText: String = ""
        
        @Published var selectedDate: Date = Date()
    }
    
}

extension CategoriesListScreen.ViewModel {
    
    var isChartDisplayed: Bool {
        return !TransactionStore.shared.getExpenses(in: selectedDate).isEmpty
    }
    
    var categoriesFiltered: [CategoryModel] {
        return categories.search(searchText)
    }
    
    func calculateAllAmounts(for date: Date) {
        let transactionStore: TransactionStore = .shared
        let groupedTransactions = Dictionary(grouping: transactionStore.transactions) { $0.category?.id }
        
        var newAmounts: [Int?: CategoryAmount] = [:]
        
        for (categoryId, transactions) in groupedTransactions {
            let totalAmount = transactions
                .filter { transaction in
                    let startOfMonth = date.startOfMonth
                    let endOfMonth = date.endOfMonth
                    return transaction.date >= startOfMonth && transaction.date <= endOfMonth
                }
                .reduce(0.0) { sum, transaction in
                    sum + transaction.amount
                }
            
            newAmounts[categoryId] = CategoryAmount(categoryId: categoryId, amount: totalAmount)
        }
        
        DispatchQueue.main.async {
            self.categoryAmounts = newAmounts
        }
    }
    
}
