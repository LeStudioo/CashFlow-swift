//
//  TransactionDetailView.swift
//  CashFlow
//
//  Created by Théo Sementa on 08/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import AlertKit
import NavigationKit
import StatsKit
import TheoKit

struct TransactionDetailView: View {

    // Builder
    var transaction: TransactionModel
    
    // Custom type
    @EnvironmentObject private var router: Router<AppDestination>
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
        VStack(spacing: TKDesignSystem.Spacing.extraLarge) {
            NavigationBarWithMenu {
                NavigationButton(
                    route: .push,
                    destination: AppDestination.transaction(.update(transaction: currentTransaction))
                ) {
                    Label(Word.Classic.edit, systemImage: "pencil")
                }
                
                Button(
                    role: .destructive,
                    action: { AlertManager.shared.deleteTransaction(transaction: currentTransaction, dismissAction: dismiss) },
                    label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
                )
            }
            
            ScrollView {
                VStack(spacing: TKDesignSystem.Spacing.extraLarge) {
                    VStack(spacing: TKDesignSystem.Spacing.small) {
                        VStack(spacing: TKDesignSystem.Spacing.extraSmall) {
                            Text("\(currentTransaction.symbol) \(currentTransaction.amount.toCurrency())")
                                .fontWithLineHeight(DesignSystem.Fonts.Display.huge)
                                .foregroundColor(currentTransaction.color)
                            
                            Text(currentTransaction.nameDisplayed)
                                .fontWithLineHeight(DesignSystem.Fonts.Display.small)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        if currentTransaction.isFromSubscription == true {
                            Text("transaction_detail_automatically_created".localized)
                                .font(.mediumText16())
                        }
                    }
                    
                    if let categoryFound = viewModel.bestCategory {
                        let subcategoryFound = viewModel.bestSubcategory
                        TransactionDetailPredictedCategoryRow(
                            category: categoryFound,
                            subcategory: subcategoryFound,
                            action: {
                                viewModel.selectedCategory = categoryFound
                                if let subcategoryFound { viewModel.selectedSubcategory = subcategoryFound }
                                viewModel.updateCategory(transactionID: currentTransaction.id)
                            }
                        )
                    }
                    
                    VStack(spacing: DesignSystem.Spacing.medium) {
                        DetailRow(
                            icon: .iconCalendar,
                            text: "transaction_detail_date".localized,
                            value: currentTransaction.date.formatted(
                                date: .complete,
                                time: currentTransaction.isFromApplePay == true ? .shortened : .omitted
                            ).capitalized
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
                        
                        if let senderAccount = currentTransaction.senderAccount {
                            DetailRow(
                                icon: .iconSend,
                                text: Word.Classic.senderAccount,
                                value: senderAccount.name
                            )
                        }
                        
                        if let receiverAccount = currentTransaction.receiverAccount {
                            DetailRow(
                                icon: .iconInbox,
                                text: Word.Classic.receiverAccount,
                                value: receiverAccount.name
                            )
                        }
                        
                        TransactionDetailNoteRow(note: $viewModel.note)
                        
                        if currentTransaction.lat != nil && currentTransaction.long != nil {
                            if #available(iOS 17.0, *) {
                                TransactionMapRow(transaction: currentTransaction)
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Padding.large)
            } // ScrollView
            .scrollIndicators(.hidden)
        }
        .onAppear {
            viewModel.note = currentTransaction.note ?? ""
            if transaction.type == .transfer {
                EventService.sendEvent(key: .transferDetailPage)
            } else {
                EventService.sendEvent(key: .transactionDetailPage)
            }
        }
        .task {
            if store.isCashFlowPro && currentTransaction.category?.id == 0 {
                guard !currentTransaction.nameDisplayed.isBlank else { return }
                let transactionID = currentTransaction.id
                if let response = await transactionStore.fetchCategory(name: currentTransaction.nameDisplayed, transactionID: transactionID) {
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
                EventService.sendEvent(key: .transactionNoteAdded)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissKeyboardButtonView()
        }
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
    } // body
} // struct

// MARK: - Utils
extension TransactionDetailView {
    
    // TODO: DUPLICATED
    func presentChangeCategory() {
        router.present(
            route: .sheet,
            .category(.select(
                selectedCategory: $viewModel.selectedCategory,
                selectedSubcategory: $viewModel.selectedSubcategory
            )
            )
        ) {
            if viewModel.selectedCategory != nil {
                viewModel.updateCategory(transactionID: currentTransaction.id)
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
