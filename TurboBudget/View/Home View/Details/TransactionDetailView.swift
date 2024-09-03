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
    @ObservedObject var transaction: TransactionEntity
    
    // Custom type
    @ObservedObject var viewModel: TransactionDetailViewModel = .init()

    // Environement
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    // EnvironmentObject
    @EnvironmentObject var store: PurchasesManager

    // String variables
    @State private var transactionNote: String = ""
    @State private var newTransactionName: String = ""
    
    // Boolean variables
    @State private var isDeleting: Bool = false
    @State private var isSharingJSON: Bool = false
    @State private var isSharingQRCode: Bool = false
    @State private var isEditingTransactionName: Bool = false
    @State private var showWhatCategory: Bool = false

	// Enum
    enum Field: CaseIterable {
        case note
    }
    @FocusState var focusedField: Field?
	
	//Computed var
    var isAnExpense: Bool { if transaction.amount < 0 { return true } else { return false} }

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
                            .onTapGesture {
                                if let category = transaction.category,
                                   category.id != PredefinedCategory.PREDEFCAT0.id,
                                   !transaction.isAuto {
                                    showWhatCategory.toggle()
                                }
                            }
                            .sheet(isPresented: $showWhatCategory, onDismiss: {
                                viewModel.changeCategory(transaction: transaction)
                            }) {
                                SelectCategoryView(
                                    selectedCategory: $viewModel.selectedCategory,
                                    selectedSubcategory: $viewModel.selectedSubcategory
                                )
                            }
                    }
                Spacer()
            }
            
            if store.isCashFlowPro && transaction.predefCategoryID == PredefinedCategory.PREDEFCAT00.id {
                let bestCategory = TransactionEntity.findBestCategory(for: transaction.title)
                
                if let categoryFound = bestCategory.0 {
                    let subcategoryFound = bestCategory.1
                    VStack(spacing: 0) {
                        Text("transaction_recommended_category".localized + " : ")
                        HStack {
                            Image(systemName: categoryFound.icon)
                            Text("\(subcategoryFound != nil ? subcategoryFound!.title : categoryFound.title)")
                        }
                        .foregroundStyle(categoryFound.color)
                    }
                    .font(.mediumText16())
                    .onTapGesture {
                        viewModel.selectedCategory = categoryFound
                        if let subcategoryFound { viewModel.selectedSubcategory = subcategoryFound }
                        viewModel.changeCategory(transaction: transaction)
                    }
                    .padding(.top, 8)
                }
            }
            
            Text(transaction.title)
                .titleAdjustSize()
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            CellForDetailTransaction(
                leftText: "transaction_detail_amount".localized,
                rightText: transaction.amount.currency,
                rightTextColor: isAnExpense ? .error400 : .primary500
            )
            
            if !transaction.isFault {
                CellForDetailTransaction(
                    leftText: "transaction_detail_date".localized,
                    rightText: transaction.date.withDefault.formatted(date: .abbreviated, time: .omitted),
                    rightTextColor: Color(uiColor: .label)
                )
            }
            
            if let category = transaction.category {
                CellForDetailTransaction(
                    leftText: "word_category".localized,
                    rightText: category.title,
                    rightTextColor: category.color
                )
                
                if let subcategory = transaction.subcategory {
                    CellForDetailTransaction(
                        leftText: "word_subcategory".localized,
                        rightText: subcategory.title,
                        rightTextColor: category.color
                    )
                }
            }
            
            HStack {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $transactionNote)
                        .focused($focusedField, equals: .note)
                        .scrollContentBackground(.hidden)
                        .font(Font.mediumText16())
                    
                    if transactionNote.isEmpty {
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
        .alert("transaction_detail_delete_transac".localized, isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { return }, label: { Text("word_cancel") })
            Button(role: .destructive, action: { withAnimation { deleteTransaction() } }, label: { Text("word_delete") })
        }, message: {
            Text(transaction.amount < 0 ? "transaction_detail_alert_if_expense".localized : "transaction_detail_alert_if_income".localized)
        })
        .alert("word_rename".localized, isPresented: $isEditingTransactionName, actions: {
            TextField("word_new_name".localized, text: $newTransactionName)
            Button(action: { return }, label: { Text("word_cancel".localized) })
            Button(action: {
                transaction.title = newTransactionName
                persistenceController.saveContext()
            }, label: { Text("word_validate".localized) })
        })
        .onAppear { 
            transactionNote = transaction.note
            viewModel.selectedCategory = PredefinedCategory.findByID(transaction.predefCategoryID)
            viewModel.selectedSubcategory = PredefinedSubcategory.findByID(transaction.predefSubcategoryID)
        }
        .onDisappear {
            if transactionNote != transaction.note {
                transaction.note = transactionNote
                persistenceController.saveContext()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button(action: { isEditingTransactionName.toggle() }, label: { Label("word_rename".localized, systemImage: "pencil") })
                    Menu(content: {
                        Button(action: { isSharingJSON.toggle() }, label: { Label("word_json".localized, systemImage: "curlybraces") })
                        Button(action: { isSharingQRCode.toggle() }, label: { Label("word_qrcode".localized, systemImage: "qrcode") })
                    }, label: {
                        Label("word_share".localized, systemImage: "square.and.arrow.up.fill")
                    })
                    Button(role: .destructive, action: { isDeleting.toggle() }, label: { Label("word_delete", systemImage: "trash.fill") })
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
        .background(SharingViewController(isPresenting: $isSharingJSON) {
            let json = JSONManager().generateJSONForTransaction(transaction: transaction)
            let av = UIActivityViewController(activityItems: [json], applicationActivities: nil)
            
            // For iPad
            if UIDevice.current.userInterfaceIdiom == .pad { av.popoverPresentationController?.sourceView = UIView() }
            
            av.completionWithItemsHandler = { _, _, _, _ in
                isSharingJSON = false // required for re-open !!!
            }
            return av
        })
        .sheet(isPresented: $isSharingQRCode) { QRCodeForTransactionSheetView(qrcode: QRCodeManager().generateQRCode(transaction: transaction)!) }
    }//END body

    //MARK: Fonctions
    func deleteTransaction() {
        if let account = transaction.transactionToAccount {
            account.deleteTransaction(transaction: transaction)
        }
        // TODO: Voir si auto reload
//        PredefinedObjectManager.shared.reloadTransactions()
        dismiss()
    }
    
}//END struct

//MARK: - Preview
#Preview {
    TransactionDetailView(transaction: TransactionEntity.preview1)
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
