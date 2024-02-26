//
//  SettingsSavingPlansView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI

struct SettingsSavingPlansView: View {
    
    // Preferences
    @Preference(\.automatedArchivedSavingPlan) var automatedArchivedSavingPlan
    @Preference(\.numberOfDayForArchivedSavingPlan) var numberOfDayForArchivedSavingPlan
    
    // Number variables
    let arrayOfDayArchived: [Int] = [0, 1, 2, 3, 5, 10, 30]
    
    // MARK: - body
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $automatedArchivedSavingPlan) {
                    Text("setting_savingsplans_automatic_archiving".localized)
                }
                if automatedArchivedSavingPlan {
                    Picker("setting_savingsplans_nbr_days".localized, selection: $numberOfDayForArchivedSavingPlan) {
                        ForEach(arrayOfDayArchived, id: \.self) { num in
                            Text(num.formatted()).tag(num)
                        }
                    }
                }
            } footer: {
                Text(automatedArchivedSavingPlan ? "setting_savingsplans_nbr_days_archiving_desc".localized : "")
            }

        }
        .navigationTitle("word_savingsplans".localized)
        .navigationBarTitleDisplayMode(.inline)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SettingsSavingPlansView()
}
