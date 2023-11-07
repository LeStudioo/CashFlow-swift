//
//  TransactionDetailView.swift
//  CashFlow
//
//  Created by Théo Sementa on 08/07/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct TransactionDetailView: View {

    //Custom type
    var transaction: Transaction
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    @ObservedObject var viewModel = TransactionDetailViewModel.shared

    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var store: Store

    //State or Binding String
    @State private var transactionNote: String = ""
    @State private var newTransactionName: String = ""
    
    //State or Binding Int, Float and Double

    //State or Binding Bool
    @Binding var update: Bool
    @State private var isDeleting: Bool = false
    @State private var isSharingJSON: Bool = false
    @State private var isSharingQRCode: Bool = false
    @State private var isEditingTransactionName: Bool = false
    @State private var showWhatCategory: Bool = false

	//Enum
    enum Field: CaseIterable {
        case note
    }
    @FocusState var focusedField: Field?
	
	//Computed var
    
    var isAnExpense: Bool { if transaction.amount < 0 { return true } else { return false} }
    
    var category: PredefinedCategory? {
        return PredefinedCategoryManager().categoryByUniqueID(idUnique: transaction.predefCategoryID)
    }
    
    var subcategory: PredefinedSubcategory? {
        if let category {
            return PredefinedSubcategoryManager().subcategoryByUniqueID(subcategories: category.subcategories, idUnique: transaction.predefSubcategoryID)
        } else {
            return nil
        }
    }

    //MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Spacer()
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.colorCell)
                    .overlay {
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(category?.color ?? .red)
                            .shadow(color: category?.color ?? .red, radius: 4, y: 2)
                            .overlay {
                                VStack {
                                    if let subcategory {
                                        Image(systemName: subcategory.icon)
                                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                                            .foregroundColor(.colorLabelInverse)
                                    } else if let category {
                                        Image(systemName: category.icon)
                                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                                            .foregroundColor(.colorLabelInverse)
                                    }
                                }
                            }
                            .onTapGesture {
                                if let category, category.idUnique != categoryPredefined0.idUnique, !transaction.isAuto {
                                    showWhatCategory.toggle()
                                }
                            }
                            .sheet(isPresented: $showWhatCategory, onDismiss: {
                                viewModel.changeCategory(transaction: transaction)
                                update.toggle()
                            }) {
                                WhatCategoryView(selectedCategory: $viewModel.selectedCategory, selectedSubcategory: $viewModel.selectedSubcategory)
                            }
                    }
                Spacer()
            }
            
            if store.isLifetimeActive && transaction.predefCategoryID == categoryPredefined00.idUnique {
                if let categoryFound = viewModel.automaticCategorySearch(title: transaction.title).0, categoryFound != categoryPredefined0 {
                    let subcategoryFound = viewModel.automaticCategorySearch(title: transaction.title).1
                    VStack(spacing: 0) {
                        Text(NSLocalizedString("transaction_recommended_category", comment: "") + " : ")
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
                        update.toggle()
                    }
                    .padding(.top, 8)
                }
            }
            
            Text(transaction.title)
                .titleAdjustSize()
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            CellForDetailTransaction(leftText: NSLocalizedString("transaction_detail_amount", comment: ""), rightText: transaction.amount.currency, rightTextColor: isAnExpense ? .error400 : .primary500)
            
            CellForDetailTransaction(leftText: NSLocalizedString("transaction_detail_date", comment: ""), rightText: transaction.date.formatted(date: .abbreviated, time: .omitted), rightTextColor: .colorLabel)
            
            if let category = PredefinedCategoryManager().categoryByUniqueID(idUnique: transaction.predefCategoryID) {
                CellForDetailTransaction(leftText: NSLocalizedString("word_category", comment: ""), rightText: category.title, rightTextColor: category.color)
                
                if let subcategory = PredefinedSubcategoryManager().subcategoryByUniqueID(subcategories: category.subcategories, idUnique: transaction.predefSubcategoryID) {
                    CellForDetailTransaction(leftText: NSLocalizedString("word_subcategory", comment: ""), rightText: subcategory.title, rightTextColor: category.color)
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
                            Text(NSLocalizedString("transaction_detail_note", comment: ""))
                                .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
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
        .alert(NSLocalizedString("transaction_detail_delete_transac", comment: ""), isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { return }, label: { Text("word_cancel") })
            Button(role: .destructive, action: { withAnimation { deleteTransaction() } }, label: { Text("word_delete") })
        }, message: {
            Text(transaction.amount < 0 ? NSLocalizedString("transaction_detail_alert_if_expense", comment: "") : NSLocalizedString("transaction_detail_alert_if_income", comment: ""))
        })
        .alert(NSLocalizedString("word_rename", comment: ""), isPresented: $isEditingTransactionName, actions: {
            TextField(NSLocalizedString("word_new_name", comment: ""), text: $newTransactionName)
            Button(action: { return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
            Button(action: {
                transaction.title = newTransactionName
                persistenceController.saveContext()
            }, label: { Text(NSLocalizedString("word_validate", comment: "")) })
        })
        .onAppear { 
            transactionNote = transaction.note
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.colorLabel)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button(action: { isEditingTransactionName.toggle() }, label: { Label(NSLocalizedString("word_rename", comment: ""), systemImage: "pencil") })
                    Menu(content: {
                        Button(action: { isSharingJSON.toggle() }, label: { Label(NSLocalizedString("word_json", comment: ""), systemImage: "curlybraces") })
                        Button(action: { isSharingQRCode.toggle() }, label: { Label(NSLocalizedString("word_qrcode", comment: ""), systemImage: "qrcode") })
                    }, label: {
                        Label(NSLocalizedString("word_share", comment: ""), systemImage: "square.and.arrow.up.fill")
                    })
                    Button(role: .destructive, action: { isDeleting.toggle() }, label: { Label("word_delete", systemImage: "trash.fill") })
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.colorLabel)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
            
            ToolbarItem(placement: .keyboard) {
                HStack {
                    EmptyView()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down.fill").foregroundColor(.primary500) })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
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
            account.balance = transaction.amount < 0 ? account.balance - transaction.amount : account.balance - transaction.amount
        }
        viewContext.delete(transaction)
        PredefinedObjectManager.shared.reloadTransactions()
        update.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            update.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            persistenceController.saveContext()
        }
        dismiss()
    }
    
}//END struct

//MARK: - Preview
struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(transaction: previewTransaction1(), update: Binding.constant(false))
    }
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
                .foregroundColor(rightTextColor)
        }
        .padding(12)
        .background(Color.colorCell)
        .cornerRadius(15)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}
