//
//  CellTransactionView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 17/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import SwipeActions

struct CellTransactionView: View {
    
    // Builder
    @ObservedObject var transaction: Transaction
    
    //Environnements
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    // State or Binding Bool
    @State private var isEditing: Bool = false
    @State private var isDeleting: Bool = false
    @State private var cancelDeleting: Bool = false
    @State private var isSharingJSON: Bool = false
    @State private var isSharingQRCode: Bool = false
    
    //MARK: - Body
    var body: some View {
        SwipeView(label: {
            HStack {
                Circle()
                    .foregroundStyle(Color.background)
                    .frame(width: 50)
                    .overlay {
                        if let category = transaction.category, let subcategory = transaction.subcategory {
                            Circle()
                                .foregroundStyle(category.color)
                                .shadow(radius: 4, y: 4)
                                .frame(width: 34)
                            
                            Image(systemName: subcategory.icon)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color(uiColor: .systemBackground))
                            
                        } else if let category = transaction.category, transaction.subcategory == nil {
                            Circle()
                                .foregroundStyle(category.color)
                                .shadow(radius: 4, y: 4)
                                .frame(width: 34)
                            
                            Image(systemName: category.icon)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color(uiColor: .systemBackground))
                        } else {
                            Circle()
                                .foregroundStyle(transaction.amount < 0 ? .error400 : .primary500)
                                .shadow(radius: 4, y: 4)
                                .frame(width: 34)
                            
                            Text(Locale.current.currencySymbol ?? "$")
                                .foregroundStyle(Color(uiColor: .systemBackground))
                        }
                    }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(transaction.amount < 0
                         ? (transaction.comeFromAuto ? "word_automation_expense".localized : "word_expense".localized)
                         : (transaction.comeFromAuto ? "word_automation_income".localized : "word_income".localized)
                    )
                    .foregroundStyle(Color.customGray)
                    .font(Font.mediumSmall())
                    
                    Text(transaction.title)
                        .font(.semiBoldText18())
                        .foregroundStyle(Color(uiColor: .label))
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text(transaction.amount.currency)
                        .font(.semiBoldText16())
                        .foregroundStyle(transaction.amount < 0 ? .error400 : .primary500)
                        .lineLimit(1)
                    
                    if !transaction.isFault {
                        Text(transaction.date.formatted(date: .numeric, time: .omitted))
                            .font(Font.mediumSmall())
                            .foregroundStyle(Color.customGray)
                            .lineLimit(1)
                    }
                }
            }
            .padding(12)
            .background(Color.colorCell)
            .cornerRadius(15)
        }, trailingActions: { context in
            SwipeAction(action: {
                withAnimation { isSharingJSON.toggle() }
            }, label: { _ in
                VStack(spacing: 5) {
                    Image(systemName: "curlybraces")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    Text("word_json".localized)
                        .font(.semiBoldCustom(size: 10))
                }
                .foregroundStyle(Color(uiColor: .systemBackground))
            }, background: { _ in
                Rectangle()
                    .foregroundStyle(.yellow)
            })
            .onChange(of: isSharingJSON) { _ in
                context.state.wrappedValue = .closed
            }
            
            SwipeAction(action: {
                withAnimation { isSharingQRCode.toggle() }
            }, label: { _ in
                VStack(spacing: 5) {
                    Image(systemName: "qrcode")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    Text("word_QRCODE".localized)
                        .font(.semiBoldCustom(size: 10))
                }
                .foregroundStyle(Color(uiColor: .systemBackground))
            }, background: { _ in
                Rectangle()
                    .foregroundStyle(.green)
            })
            .onChange(of: isSharingQRCode) { _ in
                context.state.wrappedValue = .closed
            }
            
            SwipeAction(action: {
                withAnimation { isDeleting.toggle() }
            }, label: { _ in
                VStack(spacing: 5) {
                    Image(systemName: "trash")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    Text("word_DELETE".localized)
                        .font(.semiBoldCustom(size: 10))
                }
                .foregroundStyle(Color(uiColor: .systemBackground))
            }, background: { _ in
                Rectangle()
                    .foregroundStyle(.error400)
            })
            .onChange(of: cancelDeleting) { _ in
                context.state.wrappedValue = .closed
            }
        })
        .swipeActionsStyle(.cascade)
        .swipeActionWidth(90)
        .swipeActionCornerRadius(15)
        .swipeMinimumDistance(30)
        .padding(.vertical, 4)
        .padding(.horizontal)
        .alert("transaction_detail_delete_transac".localized, isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { cancelDeleting.toggle(); return }, label: { Text("word_cancel".localized) })
            Button(role: .destructive, action: { withAnimation { deleteTransaction() } }, label: { Text("word_delete".localized) })
        }, message: {
            Text(transaction.amount < 0 ? "transaction_detail_alert_if_expense".localized : "transaction_detail_alert_if_income".localized)
        })
        .sheet(isPresented: $isSharingQRCode) { QRCodeForTransactionSheetView(qrcode: QRCodeManager().generateQRCode(transaction: transaction)!) }
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
    } // END body
    
    // MARK: Fonctions
    private func deleteTransaction() {
        if let account = transaction.transactionToAccount {
            account.deleteTransaction(transaction: transaction)
        }
        // TODO: Voir si reload
//        PredefinedObjectManager.shared.reloadTransactions()
    }

} // END struct

// MARK: - Preview
#Preview {
    Group {
        CellTransactionView(transaction: Transaction.preview1)
        CellTransactionView(transaction: Transaction.preview1)
    }
    .previewLayout(.sizeThatFits)
}
