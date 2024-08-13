//
//  SettingsDangerZoneView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI

struct SettingsDangerZoneView: View {
    
    // Custom
    @StateObject private var viewModel: SettingsDangerZoneViewModel = .init()
    
    // Repo
    @EnvironmentObject private var accountRepo: AccountRepository
    @EnvironmentObject private var transactionRepo: TransactionRepository
    @EnvironmentObject private var savingPlanRepo: SavingPlanRepository
    @EnvironmentObject private var budgetRepo: BudgetRepository
    
    // MARK: -
    var body: some View {
        Form {
            Section {
                Button(action: {
                    viewModel.info = MultipleAlert(
                        id: .six,
                        title: "setting_home_reset_settings".localized,
                        message: "setting_home_reset_settings_desc".localized,
                        action: viewModel.resetSettings
                    )
                }, label: {
                    CellSettingsView(
                        icon: "arrow.counterclockwise",
                        backgroundColor: Color.red,
                        text: "setting_home_reset_settings".localized,
                        isButton: true
                    )
                })
            }
            
            Section {
                Button(action: {
                    viewModel.info = MultipleAlert(
                        id: .seven,
                        title: "setting_home_reset_data".localized,
                        message: "setting_home_reset_data_desc".localized,
                        action: { deleteAllData() }
                    )
                }, label: {
                    CellSettingsView(
                        icon: "trash.fill",
                        backgroundColor: Color.red,
                        text: "setting_home_reset_data".localized,
                        isButton: true
                    )
                })
            }
        }
        .alert(item: $viewModel.info, content: { info in
            Alert(title: Text(info.title), message: Text(info.message),
                  primaryButton: .cancel(Text("word_cancel".localized)) { return },
                  secondaryButton: .destructive(Text(info.id == .six ? "word_reset".localized : "word_delete".localized)) {
                info.action()
                persistenceController.saveContext()
            })
        })
        .navigationTitle("setting_home_danger".localized)
        .navigationBarTitleDisplayMode(.inline)
    } // End body
    
    // MARK: - Functions
    func deleteAllData() {
        DispatchQueue.main.async {
            accountRepo.deleteAccount()
            transactionRepo.deleteTransactions()
            savingPlanRepo.deleteSavingPlans()
            budgetRepo.deleteBudgets()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            persistenceController.saveContext()
        }
    }
        
} // End struct

// MARK: - Preview
#Preview {
    SettingsDangerZoneView()
}
