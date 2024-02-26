//
//  AddContributionView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 30/09/2023

import SwiftUI
import Combine

struct AddContributionView: View {

    // Custom type
    var savingPlan: SavingPlan
    @StateObject private var viewModel = AddContributionViewModel()

    // Environement
    @Environment(\.dismiss) private var dismiss

    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback

	//Enum
    enum Field: CaseIterable {
        case amount
    }
    @FocusState var focusedField: Field?

    //Other
    var numberFormatter: NumberFormatter {
        let numFor = NumberFormatter()
        numFor.numberStyle = .decimal
        numFor.zeroSymbol = ""
        return numFor
    }

    //MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                DismissButtonInSheet()
                
                Text("contribution_new".localized)
                    .titleAdjustSize()
                
                TextField("contribution_placeholder_amount".localized, value: $viewModel.amountContribution.animation(), formatter: numberFormatter)
                    .focused($focusedField, equals: .amount)
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
                    .background(Color.color3Apple.cornerRadius(100))
                    .padding()
                    .onReceive(Just(viewModel.amountContribution)) { newValue in
                        if viewModel.amountContribution > 1_000_000_000 {
                            let numberWithoutLastDigit = HelperManager().removeLastDigit(from: viewModel.amountContribution)
                            viewModel.amountContribution = numberWithoutLastDigit
                        }
                    }
                
                CustomSegmentedControl(selection: $viewModel.typeContribution,
                                       textLeft: "contribution_add".localized,
                                       textRight: "contribution_withdraw".localized,
                                       height: isLittleIphone ? 40 : 50)
                .padding(.horizontal)

                
                ZStack {
                    Capsule()
                        .frame(height: isLittleIphone ? 40 : 50)
                        .foregroundColor(Color.color3Apple)
                    
                    HStack {
                        Spacer()
                        DatePicker("\(viewModel.dateContribution.formatted())", selection: $viewModel.dateContribution, in: savingPlan.dateOfStart..., displayedComponents: [.date])
                            .labelsHidden()
                            .clipped()
                            .padding(.horizontal)
                    }
                }
                .padding()
                
                VStack {
                    if (viewModel.amountContribution > viewModel.moneyForFinish || viewModel.moneyForFinish == 0) && viewModel.typeContribution == .expense {
                        Text("contribution_alert_more_final_amount".localized)
                    } else if (viewModel.amountContribution < viewModel.moneyForFinish || viewModel.moneyForFinish != 0) && viewModel.typeContribution == .expense {
                        Text("💰" + viewModel.moneyForFinish.currency + " " + "contribution_alert_for_finish".localized)
                    }
                    if (savingPlan.actualAmount - viewModel.amountContribution < 0) && viewModel.typeContribution == .income {
                        Text("contribution_alert_take_more_amount".localized)
                    }
                }
                .font(Font.mediumText16())
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                
                Spacer()
                
                CreateButton(action: {
                    viewModel.createContribution()
                    if hapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                    dismiss()
                }, validate: viewModel.validateContribution())
                    .padding(.horizontal, 8)
                    .padding(.bottom)
            }
            .ignoresSafeArea(.keyboard)
            .background(Color.color2Apple.edgesIgnoringSafeArea(.all).onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) } )
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        EmptyView()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down.fill").foregroundColor(HelperManager().getAppTheme().color) })
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .onAppear {
                viewModel.savingPlan = savingPlan
            }
        } // End Navigation Stack
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    AddContributionView(savingPlan: SavingPlan.preview1)
}
