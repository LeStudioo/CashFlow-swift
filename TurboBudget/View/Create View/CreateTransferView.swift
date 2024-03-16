//
//  CreateTransferView.swift
//  CashFlow
//
//  Created by KaayZenn on 16/03/2024.
//

import SwiftUI

struct CreateTransferView: View {
    
    // Custom
    @StateObject private var viewModel = CreateTransferViewModel()
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    TextField("0.00", text: $viewModel.transferAmount.max(9).animation())
                        .font(.boldCustom(size: isLittleIphone ? 24 : 30))
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .if(!isLittleIphone) { view in
                            view
                                .padding()
                        }
                        .if(isLittleIphone) { view in
                            view
                                .padding(8)
                        }
                        .background(Color.backgroundComponentSheet.cornerRadius(100))
                    
                    CustomSegmentedControl(
                        selection: $viewModel.typeTransfer,
                        textLeft: "contribution_add".localized,
                        textRight: "contribution_withdraw".localized,
                        height: isLittleIphone ? 40 : 50
                    )
                    
                    ZStack {
                        Capsule()
                            .frame(height: isLittleIphone ? 40 : 50)
                            .foregroundStyle(Color.backgroundComponentSheet)
                        
                        HStack {
                            Spacer()
                            DatePicker("\(viewModel.transferDate.formatted())", selection: $viewModel.transferDate.animation(), displayedComponents: [.date])
                                .labelsHidden()
                                .clipped()
                                .padding(.horizontal)
                        }
                    }
                    
                    ZStack {
                        Capsule()
                            .frame(height: isLittleIphone ? 40 : 50)
                            .foregroundStyle(Color.backgroundComponentSheet)
                        
                        HStack {
                            Text("word_from".localized)
                            Spacer()
                            if let mainAccount = viewModel.mainAccount {
                                Text(mainAccount.title)
                                    .padding(8)
                                    .background {
                                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                                            .foregroundStyle(Color.componentInComponent)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    ZStack {
                        Capsule()
                            .frame(height: isLittleIphone ? 40 : 50)
                            .foregroundStyle(Color.backgroundComponentSheet)
                        
                        HStack {
                            Text("word_to".localized)
                                .padding(.leading)
                            Spacer()
                            Picker(selection: $viewModel.selectedSavingsAccountID) {
                                ForEach(viewModel.savingsAccount) { account in
                                    Text(account.name).tag(account.id.uuidString)
                                }
                            } label: {
                                if let selectedSavingsAccount = viewModel.selectedSavingsAccount {
                                    Text(selectedSavingsAccount.name)
                                        .padding(8)
                                        .background {
                                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                                .foregroundStyle(Color.componentInComponent)
                                        }
                                }
                            }
                        }
                    }
                    .onChange(of: viewModel.selectedSavingsAccountID) { newValue in
                        viewModel.findSavingsAccountByID(idSearched: newValue)
                    }
                }
            } // End ScrollView
            .padding(.horizontal)
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .toolbar {
                ToolbarDismissButtonView {
                    if viewModel.isTransferInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
                
//                ToolbarCreateButtonView(isActive: viewModel.validateTrasaction()) {
//                    viewModel.createNewTransaction()
//                    if hapticFeedback {
//                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
//                    }
//                }
                
                ToolbarDismissKeyboardButtonView()
            }
        } // End NavigationStack
        .interactiveDismissDisabled(viewModel.isTransferInCreation()) {
            viewModel.presentingConfirmationDialog.toggle()
        }
        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
            Button("word_cancel_changes".localized, role: .destructive, action: { dismiss() })
            Button("word_return".localized, role: .cancel, action: { })
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CreateTransferView()
}
