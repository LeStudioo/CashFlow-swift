//
//  TransactionDetailView.swift
//  CashFlow
//
//  Created by Théo Sementa on 08/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import AlertKit

struct TransactionDetailView: View {

    // Builder
    var transaction: TransactionModel
    
    // Custom type
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var transactionStore: TransactionStore
    @StateObject var viewModel: TransactionDetailViewModel = .init()

    // Environement
    @Environment(\.dismiss) private var dismiss
    
    // EnvironmentObject
    @EnvironmentObject var store: PurchasesManager
    
    var currentTransaction: TransactionModel {
        return transactionStore.transactions.first { $0.id == transaction.id } ?? transaction
    }

    // MARK: -
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("\(currentTransaction.symbol) \(currentTransaction.amount?.toCurrency() ?? "")")
                        .font(.system(size: 48, weight: .heavy))
                        .foregroundColor(currentTransaction.color)
                    
                    Text(currentTransaction.name)
                        .font(.semiBoldH3())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                
                if let categoryFound = viewModel.bestCategory {
                    let subcategoryFound = viewModel.bestSubcategory
                    TransactionDetailPredictedCategoryRow(
                        category: categoryFound,
                        subcategory: subcategoryFound,
                        action: {
                            viewModel.selectedCategory = categoryFound
                            if let subcategoryFound { viewModel.selectedSubcategory = subcategoryFound }
                            if let transactionID = currentTransaction.id {
                                viewModel.updateCategory(transactionID: transactionID)
                            }
                        }
                    )
                }
                
                VStack(spacing: 12) {
                    DetailRow(
                        icon: "calendar",
                        text: "transaction_detail_date".localized,
                        value: currentTransaction.date.formatted(date: .complete, time: .omitted).capitalized
                    )
                    
                    if let category = currentTransaction.category {
                        DetailRow(
                            icon: category.icon,
                            value: category.name,
                            iconBackgroundColor: category.color) {
                                presentChangeCategory()
                            }
                        
                        if let subcategory = currentTransaction.subcategory {
                            DetailRow(
                                icon: subcategory.icon,
                                value: subcategory.name,
                                iconBackgroundColor: subcategory.color) {
                                    presentChangeCategory()
                                }
                        }
                    }
                    
                    TransactionDetailNoteRow(note: $viewModel.note)
                }
            }
            .padding(.horizontal)
            .padding(.top, 32)
        } // ScrollView
        .scrollIndicators(.hidden)
        .onAppear { 
            viewModel.note = currentTransaction.note ?? ""
        }
        .task {
            if store.isCashFlowPro && currentTransaction.categoryID == 0 {
                guard !currentTransaction.name.isBlank else { return }
                guard let transactionID = currentTransaction.id else { return }
                if let response = await transactionStore.fetchCategory(name: currentTransaction.name, transactionID: transactionID) {
                    if let cat = response.cat {
                        viewModel.bestCategory = CategoryStore.shared.findCategoryById(cat)
                    }
                    if let sub = response.sub {
                        viewModel.bestSubcategory = CategoryStore.shared.findSubcategoryById(sub)
                    }
                }
            }
        }
        .onDisappear {
            if viewModel.note != currentTransaction.note && !viewModel.note.isBlank {
                viewModel.updateTransaction(transactionID: currentTransaction.id)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button(
                        action: { router.presentCreateTransaction(transaction: currentTransaction) },
                        label: { Label(Word.Classic.edit, systemImage: "pencil") }
                    )
                    Button(
                        role: .destructive,
                        action: { AlertManager.shared.deleteTransaction(transaction: currentTransaction, dismissAction: dismiss) },
                        label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
                    )
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.text)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }

            ToolbarDismissKeyboardButtonView()
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Utils
extension TransactionDetailView {

    func presentChangeCategory() {
        router.presentSelectCategory(
            category: $viewModel.selectedCategory,
            subcategory: $viewModel.selectedSubcategory
        ) {
            if let transactionID = currentTransaction.id, viewModel.selectedCategory != nil {
                viewModel.updateCategory(transactionID: transactionID)
            }
        }
    }
    
}

// MARK: - Preview
#Preview {
    NavigationStack {
        TransactionDetailView(transaction: .mockClassicTransaction)
    }
    .environmentObject(TransactionStore())
    .environmentObject(PurchasesManager())
    .environmentObject(ThemeManager())
}
