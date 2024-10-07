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
    
    // Custom
    @StateObject private var viewModel: RecoverTransactionViewModel = .init()

    // Environment
    @Environment(\.dismiss) private var dismiss
    
    //Photos
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    //MARK: - Body
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    if viewModel.transaction == nil {
                        VStack {
                            
                            Text("recover_transaction".localized)
                                .titleAdjustSize()
                                .padding(.vertical, 24)
                            
                            TextField("recover_enter_json".localized, text: $viewModel.jsonString, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .padding(.bottom, 24)
                            
                            if viewModel.jsonStatus == .error {
                                Text("⚠️" + "recover_error_json".localized)
                                    .foregroundStyle(.red)
                                    .font(Font.mediumText16())
                                    .multilineTextAlignment(.center)
                                    .padding(9)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 12) {
                                Button(action: { viewModel.showQRCodeScanner.toggle() }, label: {
                                    ZStack {
                                        Capsule()
                                            .foregroundStyle(Color(uiColor: .label))
                                            .frame(height: isLittleIphone ? 40 : 50)
                                        HStack {
                                            Spacer()
                                            Text("recover_scan_qrcode".localized)
                                                .font(.semiBoldText16())
                                                .foregroundStyle(Color(uiColor: .systemBackground))
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
                                                .foregroundStyle(Color(uiColor: .label))
                                                .frame(height: isLittleIphone ? 40 : 50)
                                            HStack {
                                                Spacer()
                                                Text("recover_import_qrcode".localized)
                                                    .font(.semiBoldText16())
                                                    .foregroundStyle(Color(uiColor: .systemBackground))
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
                                                        viewModel.jsonString = row.messageString ?? "recover_error_qrcode".localized
                                                    }
                                                }
                                            }
                                        }
                                    }
                            }
                            .padding(.bottom)
                        }
                        .frame(minHeight: geometry.size.height)
                    } else if viewModel.transaction != nil && viewModel.jsonStatus == .success {
                        VStack { // Successful TransactionEntity
                            Circle()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(ThemeManager.theme.color)
                                .overlay {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.primary0)
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                }
                                .padding(.vertical, 50)
                                .confettiCannon(
                                    counter: $viewModel.confettiCounter,
                                    num: 50,
                                    openingAngle: Angle(degrees: 0),
                                    closingAngle: Angle(degrees: 360),
                                    radius: 200
                                )
                            
                            VStack(spacing: 20) {
                                Text("recover_successful".localized)
                                    .font(.semiBoldCustom(size: 28))
                                    .foregroundStyle(Color(uiColor: .label))
                                
                                Text("recover_successful_desc".localized)
                                    .font(Font.mediumSmall())
                                    .foregroundStyle(.secondary400)
                            }
                            .padding(.bottom, 30)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    viewModel.confettiCounter += 1
                                }
                            }
                            
                            if let transaction = viewModel.transaction {
                                VStack {
                                    CellTransactionWithoutAction(transaction: transaction)
                                    
                                    HStack {
                                        Text("recover_successful_date".localized)
                                            .font(Font.mediumSmall())
                                            .foregroundStyle(.secondary400)
                                        Spacer()
                                        Text(transaction.date.withDefault.formatted(date: .abbreviated, time: .omitted))
                                            .font(.semiBoldSmall())
                                            .foregroundStyle(Color(uiColor: .label))
                                    }
                                    .padding(.horizontal, 8)
                                }
                            }
                            
                            Button(action: { viewModel.isRenaming.toggle() }, label: {
                                HStack {
                                    Spacer()
                                    Text("recover_successful_rename".localized)
                                        .font(Font.mediumText16())
                                }
                                .padding(8)
                            })
                            .alert("recover_successful_rename".localized, isPresented: $viewModel.isRenaming, actions: {
                                TextField("recover_successful_new_name".localized, text: $viewModel.transactionName)
                                Button(action: { return }, label: { Text("word_cancel".localized) })
                                Button(action: {
                                    if let transaction = viewModel.transaction, !viewModel.transactionName.isEmpty {
                                        transaction.title = viewModel.transactionName
                                    }
                                }, label: { Text("word_validate".localized) })
                            })
                            
                            Spacer()
                            
                            ValidateButton(action: {
                                viewModel.confirmTransaction()
                                dismiss()
                            }, validate: viewModel.transaction?.transactionToAccount != nil ? true : false)
                            .padding(.bottom)
                        }
                        .frame(minHeight: geometry.size.height)
                        .ignoresSafeArea(.keyboard)
                    }
                } // End ScrollView
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.immediately)
                .padding(.horizontal)
            } // End GeometryReader
            .sheet(isPresented: $viewModel.showQRCodeScanner, content: {
                QRCodeScannerView(jsonString: $viewModel.jsonString)
            })
            .toolbar {
                if viewModel.transaction == nil {
                    ToolbarDismissButtonView {
                        if viewModel.isRecovering() {
                            viewModel.presentingConfirmationDialog.toggle()
                        } else {
                            dismiss()
                        }
                    }
                    
                    ToolbarCreateButtonView(isActive: !viewModel.jsonString.isEmpty) {
                        VibrationManager.vibration()
                        viewModel.recoverTransaction()
                    }
                    
                    ToolbarDismissKeyboardButtonView()
                }
            }
        } // End NavigationStack
        .interactiveDismissDisabled(viewModel.isRecovering()) {
            viewModel.presentingConfirmationDialog.toggle()
        }
        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
            Button("word_cancel_changes".localized, role: .destructive, action: { dismiss() })
            Button("word_return".localized, role: .cancel, action: { })
        }
    } // End body
} // End struct

//MARK: - Preview
#Preview {
    RecoverTransactionView()
}
