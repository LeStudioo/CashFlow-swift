//
//  RecoverTransactionView.swift
//  CashFlow
//
//  Created by Théo Sementa on 25/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import ConfettiSwiftUI
import PhotosUI

struct RecoverTransactionView: View {

    //Custom type
    @Binding var account: Account?
    @State private var transaction: Transaction? = nil

    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    //State or Binding String
    @State private var jsonString: String = ""
    @State private var transactionName: String = ""

    //State or Binding Int, Float and Double
    @State private var confettiCounter: Int = 0
    @State private var accountNumber: Int = 0

    //State or Binding Bool
    @State private var update: Bool = false
    @State private var showQRCodeScanner: Bool = false
    @State private var showImportQRCode: Bool = false
    @State private var isRenaming: Bool = false
    
    //Photos
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
	//Enum
    @State private var jsonStatus: DecodeJSONStatus = .none
	
	//Computed var
    
    //Other
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }

    //MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                if transaction == nil {
                    VStack {
                        DismissButtonInSheet()
                        
                        Text("recover_transaction".localized)
                            .titleAdjustSize()
                        
                        TextField("recover_enter_json".localized, text: $jsonString, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .padding(8)
                        
                        if jsonStatus == .error {
                            Text("⚠️" + "recover_error_json".localized)
                                .foregroundColor(.red)
                                .font(Font.mediumText16())
                                .multilineTextAlignment(.center)
                                .padding(9)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Button(action: { showQRCodeScanner.toggle() }, label: {
                                ZStack {
                                    Capsule()
                                        .foregroundColor(.colorLabel)
                                        .frame(height: isLittleIphone ? 40 : 50)
                                    HStack {
                                        Spacer()
                                        Text("recover_scan_qrcode".localized)
                                            .font(.semiBoldText16())
                                            .foregroundColor(.colorLabelInverse)
                                        Spacer()
                                    }
                                }
                            })
                            
                            PhotosPicker(
                                selection: $selectedItem,
                                matching: .images,
                                photoLibrary: .shared()) {
                                    ZStack {
                                        Capsule()
                                            .foregroundColor(.colorLabel)
                                            .frame(height: isLittleIphone ? 40 : 50)
                                        HStack {
                                            Spacer()
                                            Text("recover_import_qrcode".localized)
                                                .font(.semiBoldText16())
                                                .foregroundColor(.colorLabelInverse)
                                            Spacer()
                                        }
                                    }
                                }
                                .onChange(of: selectedItem) { newItem in
                                    Task {
                                        // Retrive selected asset in the form of Data
                                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                            selectedImageData = data
                                            if let features = QRCodeManager().detectQRCode(UIImage(data: data)), !features.isEmpty{
                                                for case let row as CIQRCodeFeature in features {
                                                    jsonString = row.messageString ?? "recover_error_qrcode".localized
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                        
                        // Recover Button
                        Button(action: {
                            if let account {
                                if let newTransaction = JSONManager().decodeJSON(account: account, jsonString: jsonString) {
                                    withAnimation {
                                        transaction = newTransaction
                                        jsonStatus = .success
                                    }
                                } else {
                                    withAnimation {
                                        jsonStatus = .error
                                    }
                                }
                            }
                        }, label: {
                            ZStack {
                                Capsule()
                                    .foregroundColor(HelperManager().getAppTheme().color)
                                    .frame(height: isLittleIphone ? 50 : 60)
                                    .if(!jsonString.isEmpty, transform: { view in
                                        view.shadow(color: HelperManager().getAppTheme().color, radius: 8)
                                    })
                                        HStack {
                                        Spacer()
                                        Text("recover_button".localized)
                                            .font(.semiBoldCustom(size: 20))
                                            .foregroundColor(.primary0)
                                        Spacer()
                                    }
                            }
                        })
                        .disabled(jsonString.isEmpty)
                        .opacity(jsonString.isEmpty ? 0.4 : 1)
                        .padding(.horizontal, 8)
                        .padding(.bottom)
                    }
                } else if transaction != nil && jsonStatus == .success {
                    VStack { // Successful Transaction
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(HelperManager().getAppTheme().color)
                            .overlay {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.primary0)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                            }
                            .padding(.vertical, 50)
                            .confettiCannon(counter: $confettiCounter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                        
                        VStack(spacing: 20) {
                            Text("recover_successful".localized)
                                .font(.semiBoldCustom(size: 28))
                                .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                            
                            Text("recover_successful_desc".localized)
                                .font(Font.mediumSmall())
                                .foregroundColor(.secondary400)
                        }
                        .padding(.bottom, 30)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                confettiCounter += 1
                            }
                        }
                        
                        if let transaction {
                            VStack {
                                CellTransactionWithoutAction(transaction: transaction)
                                
                                HStack {
                                    Text("recover_successful_date".localized)
                                        .font(Font.mediumSmall())
                                        .foregroundColor(.secondary400)
                                    Spacer()
                                    Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.semiBoldSmall())
                                        .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                                }
                                .padding(.horizontal, 8)
                            }
                        }
                        
                        Button(action: { isRenaming.toggle() }, label: {
                            HStack {
                                Spacer()
                                Text("recover_successful_rename".localized)
                                    .font(Font.mediumText16())
                            }
                            .padding(8)
                        })
                        .alert("recover_successful_rename".localized, isPresented: $isRenaming, actions: {
                            TextField("recover_successful_new_name".localized, text: $transactionName)
                            Button(action: { return }, label: { Text("word_cancel".localized) })
                            Button(action: {
                                if let transaction, !transactionName.isEmpty {
                                    transaction.title = transactionName
                                    update.toggle()
                                }
                            }, label: { Text("word_validate".localized) })
                        })
                        
                        Spacer()

                        ValidateButton(action: {
                            dismiss()
                            if let account, let transaction {
                                account.balance += transaction.amount
                            }
                            persistenceController.saveContext()
                        }, validate: transaction?.transactionToAccount != nil ? true : false)
                        .padding(.horizontal, 8)
                        .padding(.bottom)
                    }
                    .padding()
                    .padding(update ? 0 : 0)
                }
            }
            .ignoresSafeArea(.keyboard)
            .sheet(isPresented: $showQRCodeScanner, content: {
                QRCodeScannerView(jsonString: $jsonString)
            })
            .background(Color.color2Apple.edgesIgnoringSafeArea(.all).onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) } )
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        EmptyView()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }, label: { Image(systemName: "keyboard.chevron.compact.down.fill").foregroundColor(HelperManager().getAppTheme().color) })
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        } //End NavigationStack
    }//END body

    //MARK: Fonctions
    

}//END struct

//MARK: - Preview
struct RecoverTransactionView_Previews: PreviewProvider {
    
    @State static var isTransactionRecoveredPreview: Bool = false
    @State static var previewAccount: Account? = Account.preview
    
    static var previews: some View {
        RecoverTransactionView(account: $previewAccount)
    }
}
