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
    
    //Custom type
    var transaction: Transaction
    
    //Environnements
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding String
    
    //State or Binding Int, Float and Double
    
    //State or Binding Bool
    @Binding var update: Bool
    @State private var isEditing: Bool = false
    @State private var isDeleting: Bool = false
    @State private var cancelDeleting: Bool = false
    @State private var isSharingJSON: Bool = false
    @State private var isSharingQRCode: Bool = false
    
    //Enum
    
    //Computed var
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
        SwipeView(label: {
            HStack {
                Circle()
                    .foregroundColor(.color2Apple)
                    .frame(width: 50)
                    .overlay {
                        if let category, let subcategory {
                            Circle()
                                .foregroundColor(category.color)
                                .shadow(radius: 4, y: 4)
                                .frame(width: 34)
                            
                            Image(systemName: subcategory.icon)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.colorLabelInverse)
                            
                        } else if let category, subcategory == nil {
                            Circle()
                                .foregroundColor(category.color)
                                .shadow(radius: 4, y: 4)
                                .frame(width: 34)
                            
                            Image(systemName: category.icon)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.colorLabelInverse)
                        } else {
                            Circle()
                                .foregroundColor(transaction.amount < 0 ? .error400 : .primary500)
                                .shadow(radius: 4, y: 4)
                                .frame(width: 34)
                            
                            Text(Locale.current.currencySymbol ?? "$")
                                .foregroundColor(.colorLabelInverse)
                        }
                    }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(transaction.amount < 0
                         ? (transaction.comeFromAuto ? NSLocalizedString("word_automation_expense", comment: "") : NSLocalizedString("word_expense", comment: ""))
                         : (transaction.comeFromAuto ? NSLocalizedString("word_automation_income", comment: "") : NSLocalizedString("word_income", comment: "")))
                    .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                    .font(Font.mediumSmall())
                    Text(transaction.title)
                        .font(.semiBoldText18())
                        .foregroundColor(.colorLabel)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text(transaction.amount.currency)
                        .font(.semiBoldText16())
                        .foregroundColor(transaction.amount < 0 ? .error400 : .primary500)
                        .lineLimit(1)
                    Text(transaction.date.formatted(date: .numeric, time: .omitted))
                        .font(Font.mediumSmall())
                        .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                        .lineLimit(1)
                }
            }
            .padding(12)
            .background(Color.colorCell)
            .cornerRadius(15)
//        }, leadingActions: { context in
//            SwipeAction(action: {
//                withAnimation {
//                    isEditing.toggle()
//                    if transaction.isArchived { transaction.isArchived = false } else { transaction.isArchived = true }
//                    update.toggle()
//                    Task {
//                        persistenceController.saveContext()
//                    }
//                }
//            }, label: { _ in
//                VStack(spacing: 5) {
//                    Image(systemName: transaction.isArchived ? "tray.and.arrow.up.fill" : "tray.and.arrow.down.fill")
//                        .font(.system(size: 20, weight: .semibold, design: .rounded))
//                    Text(transaction.isArchived ? NSLocalizedString("word_UNARCHIVE", comment: "") : NSLocalizedString("word_ARCHIVE", comment: ""))
//                        .font(.semiBoldCustom(size: 10))
//                }
//                    .foregroundColor(.colorLabelInverse)
//            }, background: { _ in
//                Rectangle()
//                    .foregroundColor(.blue)
//            })
//            .onChange(of: isEditing) { _ in
//                context.state.wrappedValue = .closed
//            }
        }, trailingActions: { context in
            SwipeAction(action: {
                withAnimation { isSharingJSON.toggle() }
            }, label: { _ in
                VStack(spacing: 5) {
                    Image(systemName: "curlybraces")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    Text(NSLocalizedString("word_json", comment: ""))
                        .font(.semiBoldCustom(size: 10))
                }
                .foregroundColor(.colorLabelInverse)
            }, background: { _ in
                Rectangle()
                    .foregroundColor(.yellow)
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
                    Text(NSLocalizedString("word_QRCODE", comment: ""))
                        .font(.semiBoldCustom(size: 10))
                }
                .foregroundColor(.colorLabelInverse)
            }, background: { _ in
                Rectangle()
                    .foregroundColor(.green)
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
                    Text(NSLocalizedString("word_DELETE", comment: ""))
                        .font(.semiBoldCustom(size: 10))
                }
                .foregroundColor(.colorLabelInverse)
            }, background: { _ in
                Rectangle()
                    .foregroundColor(.error400)
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
        .padding(update ? 0 : 0)
        .alert(NSLocalizedString("transaction_detail_delete_transac", comment: ""), isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { cancelDeleting.toggle(); return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
            Button(role: .destructive, action: { withAnimation { deleteTransaction() } }, label: { Text(NSLocalizedString("word_delete", comment: "")) })
        }, message: {
            Text(transaction.amount < 0 ? NSLocalizedString("transaction_detail_alert_if_expense", comment: "") : NSLocalizedString("transaction_detail_alert_if_income", comment: ""))
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
    }

}//END struct

//MARK: - Preview
#Preview {
    Group {
        CellTransactionView(transaction: previewTransaction1(), update: Binding.constant(false))
        CellTransactionView(transaction: previewTransaction5(), update: Binding.constant(false))
    }
    .previewLayout(.sizeThatFits)
}
