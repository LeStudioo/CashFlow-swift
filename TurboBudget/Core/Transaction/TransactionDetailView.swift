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
    @ObservedObject var transaction: TransactionModel
    
    // Custom type
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var transactionRepository: TransactionRepository
    @EnvironmentObject private var alertManager: AlertManager
    @ObservedObject var viewModel: TransactionDetailViewModel = .init()

    // Environement
    @Environment(\.dismiss) private var dismiss
    
    // EnvironmentObject
    @EnvironmentObject var store: PurchasesManager

    // MARK: -
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("\(transaction.symbol) \(transaction.amount?.toCurrency() ?? "")")
                        .font(.system(size: 48, weight: .heavy))
                        .foregroundColor(transaction.color)
                    
                    Text(transaction.name)
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
                            if let transactionID = transaction.id {
                                viewModel.updateCategory(transactionID: transactionID)
                            }
                        }
                    )
                }
                
                VStack(spacing: 12) {
                    DetailRow(
                        icon: "calendar",
                        text: "transaction_detail_date".localized,
                        value: transaction.date.formatted(date: .complete, time: .omitted).capitalized
                    )
                    
                    if let category = transaction.category {
                        DetailRow(
                            icon: category.icon,
                            value: category.name,
                            iconBackgroundColor: category.color) {
                                presentChangeCategory()
                            }
                        
                        if let subcategory = transaction.subcategory {
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
            viewModel.note = transaction.note ?? ""
        }
        .task {
            if store.isCashFlowPro && transaction.categoryID == 0 {
                guard !transaction.name.isBlank else { return }
                guard let transactionID = transaction.id else { return }
                if let response = await transactionRepository.fetchCategory(name: transaction.name, transactionID: transactionID) {
                    if let cat = response.cat {
                        viewModel.bestCategory = CategoryRepository.shared.findCategoryById(cat)
                    }
                    if let sub = response.sub {
                        viewModel.bestSubcategory = CategoryRepository.shared.findSubcategoryById(sub)
                    }
                }
            }
        }
        .onDisappear {
            if viewModel.note != transaction.note && !viewModel.note.isBlank {
                viewModel.updateTransaction(transactionID: transaction.id)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button(
                        action: { router.presentCreateTransaction(transaction: transaction) },
                        label: { Label(Word.Classic.edit, systemImage: "pencil") }
                    )
                    Button(
                        role: .destructive,
                        action: { alertManager.deleteTransaction(transaction: transaction, dismissAction: dismiss) },
                        label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
                    )
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color(uiColor: .label))
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
            if let transactionID = transaction.id, viewModel.selectedCategory != nil {
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
    .environmentObject(TransactionRepository())
    .environmentObject(PurchasesManager())
    .environmentObject(ThemeManager())
}
