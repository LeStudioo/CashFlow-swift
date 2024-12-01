//
//  TransactionDetailView.swift
//  CashFlow
//
//  Created by Théo Sementa on 08/07/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct TransactionDetailView: View {

    // Builder
    @ObservedObject var transaction: TransactionModel
    
    // Custom type
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var transactionRepository: TransactionRepository
    @ObservedObject var viewModel: TransactionDetailViewModel = .init()

    // Environement
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    // EnvironmentObject
    @EnvironmentObject var store: PurchasesManager

	// Enum
    enum Field: CaseIterable {
        case note
    }
    @FocusState var focusedField: Field?
	
    //MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Spacer()
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.colorCell)
                    .overlay {
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(transaction.category?.color ?? .red)
                            .shadow(color: transaction.category?.color ?? .red, radius: 4, y: 2)
                            .overlay {
                                VStack {
                                    if let subcategory = transaction.subcategory {
                                        Image(systemName: subcategory.icon)
                                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                                            .foregroundStyle(Color(uiColor: .systemBackground))
                                    } else if let category = transaction.category {
                                        Image(systemName: category.icon)
                                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                                            .foregroundStyle(Color(uiColor: .systemBackground))
                                    }
                                }
                            }
                    }
                    .onTapGesture {
                        router.presentSelectCategory(
                            category: $viewModel.selectedCategory,
                            subcategory: $viewModel.selectedSubcategory
                        ) {
                            if let transactionID = transaction.id, viewModel.selectedCategory != nil {
                                viewModel.updateCategory(transactionID: transactionID)
                            }
                        }
                    }
                Spacer()
            }
            
            if let categoryFound = viewModel.bestCategory {
                let subcategoryFound = viewModel.bestSubcategory
                VStack(spacing: 0) {
                    Text("transaction_recommended_category".localized + " : ")
                    HStack {
                        Image(systemName: categoryFound.icon)
                        Text("\(subcategoryFound != nil ? subcategoryFound!.name : categoryFound.name)")
                    }
                    .foregroundStyle(categoryFound.color)
                }
                .font(.mediumText16())
                .onTapGesture {
                    viewModel.selectedCategory = categoryFound
                    if let subcategoryFound { viewModel.selectedSubcategory = subcategoryFound }
                    if let transactionID = transaction.id {
                        viewModel.updateCategory(transactionID: transactionID)
                    }
                }
                .padding(.top, 8)
            }
            
            Text(transaction.name ?? "")
                .titleAdjustSize()
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            CellForDetailTransaction(
                leftText: "transaction_detail_amount".localized,
                rightText: transaction.amount?.currency ?? "",
                rightTextColor: transaction.type == .expense ? .error400 : .primary500
            )
            
            CellForDetailTransaction(
                leftText: "transaction_detail_date".localized,
                rightText: transaction.date.formatted(date: .abbreviated, time: .omitted),
                rightTextColor: Color(uiColor: .label)
            )
            
            if let category = transaction.category {
                CellForDetailTransaction(
                    leftText: "word_category".localized,
                    rightText: category.name,
                    rightTextColor: category.color
                )
                
                if let subcategory = transaction.subcategory {
                    CellForDetailTransaction(
                        leftText: "word_subcategory".localized,
                        rightText: subcategory.name,
                        rightTextColor: category.color
                    )
                }
            }
            
            HStack {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $viewModel.note)
                        .focused($focusedField, equals: .note)
                        .scrollContentBackground(.hidden)
                        .font(Font.mediumText16())
                    
                    if viewModel.note.isEmpty {
                        HStack {
                            Text("transaction_detail_note".localized)
                                .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                                .font(Font.mediumText16())
                            Spacer()
                        }
                        .padding([.leading, .top], 8)
                        .onTapGesture { focusedField = .note }
                    }
                }
            }
            .padding(12)
            .background(Color.colorCell)
            .frame(minHeight: 100)
            .cornerRadius(15)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            
            Spacer()
        }
        .alert("transaction_detail_delete_transac".localized, isPresented: $viewModel.isDeleting, actions: {
            Button(role: .cancel, action: { return }, label: { Text("word_cancel") })
            Button(role: .destructive, action: {
                viewModel.deleteTransaction(transactionID: transaction.id, dismiss: dismiss)
            }, label: { Text("word_delete") })
        }, message: {
            Text(transaction.type == .expense ? "transaction_detail_alert_if_expense".localized : "transaction_detail_alert_if_income".localized)
        })
        .onAppear { 
            viewModel.note = transaction.note ?? ""
        }
        .task {
            if store.isCashFlowPro && transaction.categoryID == 0 {
                guard let name = transaction.name else { return }
                guard let transactionID = transaction.id else { return }
                if let response = await transactionRepository.fetchCategory(name: name, transactionID: transactionID) {
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
            if viewModel.note != transaction.note && transaction.note != nil {
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
                    Button(role: .destructive, action: {
                        viewModel.isDeleting.toggle()
                    }, label: { Label("word_delete", systemImage: "trash.fill") })
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
            
            ToolbarItem(placement: .keyboard) {
                HStack {
                    EmptyView()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down.fill").foregroundStyle(.primary500) })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
//        .background(SharingViewController(isPresenting: $isSharingJSON) {
//            let json = JSONManager().generateJSONForTransaction(transaction: transaction)
//            let av = UIActivityViewController(activityItems: [json], applicationActivities: nil)
//            
//            // For iPad
//            if UIDevice.current.userInterfaceIdiom == .pad { av.popoverPresentationController?.sourceView = UIView() }
//            
//            av.completionWithItemsHandler = { _, _, _, _ in
//                isSharingJSON = false // required for re-open !!!
//            }
//            return av
//        })
//        .sheet(isPresented: $isSharingQRCode) { QRCodeForTransactionSheetView(qrcode: QRCodeManager().generateQRCode(transaction: transaction)!) }
    }//END body
}//END struct

//MARK: - Preview
#Preview {
    TransactionDetailView(transaction: .mockClassicTransaction)
}

private struct CellForDetailTransaction: View {
    
    var leftText: String
    var rightText: String
    var rightTextColor: Color
    
    var body: some View {
        HStack {
            Text(leftText)
                .font(Font.mediumText16())
            Spacer()
            Text(rightText)
                .font(.semiBoldText16())
                .foregroundStyle(rightTextColor)
        }
        .padding(12)
        .background(Color.colorCell)
        .cornerRadius(15)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}
