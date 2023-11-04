//
//  SettingFinancialAdviceView.swift
//  CashFlow
//
//  Created by KaayZenn on 28/08/2023.
//
// Localizations 01/10/2023

import Foundation
import SwiftUI
import Setting
import CoreData

struct FinancialAdvice: Identifiable {
    var id: UUID = UUID()
    var title: String
    var explication: String
}

var fa1: FinancialAdvice = FinancialAdvice(title: NSLocalizedString("setting_financiel_advice_first", comment: ""), explication: NSLocalizedString("setting_financiel_advice_first_desc", comment: ""))
var fa2: FinancialAdvice = FinancialAdvice(title: NSLocalizedString("setting_financiel_advice_second", comment: ""), explication: NSLocalizedString("setting_financiel_advice_second_desc", comment: ""))
var fa3: FinancialAdvice = FinancialAdvice(title: NSLocalizedString("setting_financiel_advice_third", comment: ""), explication: NSLocalizedString("setting_financiel_advice_third_desc", comment: ""))
var fa4: FinancialAdvice = FinancialAdvice(title: NSLocalizedString("setting_financiel_advice_fourth", comment: ""), explication: NSLocalizedString("setting_financiel_advice_fourth_desc", comment: ""))
var fa5: FinancialAdvice = FinancialAdvice(title: NSLocalizedString("setting_financiel_advice_fifth", comment: ""), explication: NSLocalizedString("setting_financiel_advice_fifth_desc", comment: ""))
var fa6: FinancialAdvice = FinancialAdvice(title: NSLocalizedString("setting_financiel_advice_sixth", comment: ""), explication: NSLocalizedString("setting_financiel_advice_sixth_desc", comment: ""))
var fa7: FinancialAdvice = FinancialAdvice(title: NSLocalizedString("setting_financiel_advice_seventh", comment: ""), explication: NSLocalizedString("setting_financiel_advice_seventh_desc", comment: ""))
var fa8: FinancialAdvice = FinancialAdvice(title: NSLocalizedString("setting_financiel_advice_eighth", comment: ""), explication: NSLocalizedString("setting_financiel_advice_eighth_desc", comment: ""))
var fa9: FinancialAdvice = FinancialAdvice(title: NSLocalizedString("setting_financiel_advice_ninth", comment: ""), explication: NSLocalizedString("setting_financiel_advice_ninth_desc", comment: ""))
var fa10: FinancialAdvice = FinancialAdvice(title: NSLocalizedString("setting_financiel_advice_tenth", comment: ""), explication: NSLocalizedString("setting_financiel_advice_tenth_desc", comment: ""))

func settingFinancialAdviceView(isDarkMode: Binding<Bool>) -> SettingPage {

    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    @State var isDarkMode: Bool = isDarkMode.wrappedValue
    
    //MARK: ViewBuilder
    @ViewBuilder
    func cellForFA(fa: FinancialAdvice) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(fa.title)
                Spacer()
            }
            .font(.semiBoldH3())
            Text(fa.explication)
                .font(Font.mediumText16())
                .foregroundColor(isDarkMode ? .secondary300 : .secondary400)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 8)
        }
    }
        
    //MARK: View
    return SettingPage(title: NSLocalizedString("word_financial_advice", comment: "")) {
        SettingCustomView {
            VStack { cellForFA(fa: fa1) }
            .padding(12)
            
            VStack { cellForFA(fa: fa2) }
            .padding(12)
            
            VStack { cellForFA(fa: fa3) }
            .padding(12)
            
            VStack(spacing: 0) {
                cellForFA(fa: fa4)
                Toggle(isOn: $userDefaultsManager.isStepsEnbaleForAllSavingsPlans, label: {
                    Text(NSLocalizedString("setting_financiel_advice_steps", comment: " "))
                })
                .foregroundColor(.colorLabel)
                .padding(8)
                .background(Color.colorCell)
                .cornerRadius(12)
            }
            .padding(12)
            
            VStack(spacing: 0) {
                cellForFA(fa: fa5)
                Toggle(isOn: $userDefaultsManager.isNoSpendChallengeEnbale, label: {
                    Text(NSLocalizedString("setting_financiel_advice_challenge", comment: ""))
                })
                .foregroundColor(.colorLabel)
                .padding(8)
                .background(Color.colorCell)
                .cornerRadius(12)
            }
            .padding(12)
            
            VStack(spacing: 0) {
                cellForFA(fa: fa6)
                Toggle(isOn: $userDefaultsManager.isBuyingQualityEnable, label: {
                    Text(NSLocalizedString("setting_financiel_advice_quality", comment: ""))
                })
                .foregroundColor(.colorLabel)
                .padding(8)
                .background(Color.colorCell)
                .cornerRadius(12)
            }
            .padding(12)
            
            VStack(spacing: 0) {
                cellForFA(fa: fa7)
                Toggle(isOn: $userDefaultsManager.isPayingYourselfFirstEnable, label: {
                    Text(NSLocalizedString("setting_financiel_advice_yourself", comment: ""))
                })
                .foregroundColor(.colorLabel)
                .padding(8)
                .background(Color.colorCell)
                .cornerRadius(12)
            }
            .padding(12)
            
            VStack { cellForFA(fa: fa8) }
            .padding(12)
            
            VStack(spacing: 0) {
                cellForFA(fa: fa9)
                Toggle(isOn: $userDefaultsManager.isSearchDuplicateEnable, label: {
                    Text(NSLocalizedString("setting_financiel_advice_duplicate", comment: ""))
                })
                .foregroundColor(.colorLabel)
                .padding(8)
                .background(Color.colorCell)
                .cornerRadius(12)
            }
            .padding(12)
            
            VStack { cellForFA(fa: fa10) }
            .padding(12)
        }
    }
    .previewIcon("text.book.closed.fill", foregroundColor: .white, backgroundColor: .green)
}
