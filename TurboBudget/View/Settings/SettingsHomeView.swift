//
//  SettingsHomeView.swift
//  CashFlow
//
//  Created by KaayZenn on 24/02/2024.
//

import SwiftUI

struct SettingsHomeView: View {
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    // EnvironementObject
    @EnvironmentObject var store: PurchasesManager
    
    // Boolean variables
    @State private var isSharing: Bool = false
    
    // MARK: - body
    var body: some View {
        Form {
            Section {
                NavigationButton(present: router.presentPaywall()) {
                    SettingRow(
                        icon: "crown.fill",
                        backgroundColor: Color.primary500,
                        text: "setting_home_cashflow_pro".localized,
                        isButton: true
                    )
                }
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Section {
                NavigationButton(push: router.pushSettingsGeneral()) {
                    SettingRow(
                        icon: "gearshape.fill",
                        backgroundColor: Color.gray,
                        text: "setting_general_title".localized,
                        isButton: false
                    )
                }
                
                NavigationButton(push: router.pushSettingsSecurity()) {
                    SettingRow(
                        icon: "lock.fill",
                        backgroundColor: Color.green,
                        text: "setting_security_title".localized,
                        isButton: false
                    )
                }
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Section {
                NavigationButton(push: router.pushSettingsAppearence()) {
                    SettingRow(
                        icon: "sun.max.fill",
                        backgroundColor: Color.indigo,
                        text: "setting_home_appearance".localized,
                        isButton: false
                    )
                }
                
                NavigationButton(push: router.pushSettingsDisplay()) {
                    SettingRow(
                        icon: "apps.iphone",
                        backgroundColor: Color.blue,
                        text: "setting_display_title".localized,
                        isButton: false
                    )
                }
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Section {
                NavigationButton(push: router.pushSettingsAccount()) {
                    SettingRow(
                        icon: "person.fill",
                        backgroundColor: Color.blue,
                        text: "word_account".localized,
                        isButton: false
                    )
                }
                
                NavigationButton(push: router.pushSettingsSavingPlans()) {
                    SettingRow(
                        icon: "dollarsign.square.fill",
                        backgroundColor: Color.pink,
                        text: "word_savingsplans".localized,
                        isButton: false
                    )
                }
                
                NavigationButton(push: store.isCashFlowPro ? router.pushSettingsBudget() : router.presentPaywall()) {
                    SettingRow(
                        icon: "chart.pie.fill",
                        backgroundColor: Color.purple,
                        text: "word_budgets".localized,
                        isButton: false,
                        isLocked: store.isCashFlowPro ? false : true
                    )
                }
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Section {
                Button(action: { URLManager.Setting.writeReview() }, label: {
                    SettingRow(
                        icon: "star.fill",
                        backgroundColor: Color.orange,
                        text: "setting_home_write_review".localized,
                        isButton: true
                    )
                })
                
                Button(action: { isSharing.toggle() }, label: {
                    SettingRow(
                        icon: "square.and.arrow.up.fill",
                        backgroundColor: Color.blue,
                        text: "setting_home_share_app".localized,
                        isButton: true
                    )
                })
                
                Button(action: { URLManager.Setting.reportBug() }, label: {
                    SettingRow(
                        icon: "exclamationmark.triangle.fill",
                        backgroundColor: Color.red,
                        text: "setting_home_report_bug".localized,
                        isButton: true
                    )
                })
                
                Button(action: { URLManager.Setting.suggestFeature() }, label: {
                    SettingRow(
                        icon: "wand.and.stars",
                        backgroundColor: Color.purple,
                        text: "setting_home_new_features".localized,
                        isButton: true
                    )
                })
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Section {
                NavigationButton(push: router.pushSettingsCredits()) {
                    SettingRow(
                        icon: "person.fill",
                        backgroundColor: Color.indigo,
                        text: "setting_credits_title".localized,
                        isButton: false
                    )
                }
                
                Button(action: { URLManager.Setting.showDeveloperAccount() }, label: {
                    SettingRow(
                        icon: "app.badge.checkmark.fill",
                        backgroundColor: Color.blue,
                        text: "setting_home_more_from_dev".localized,
                        isButton: true
                    )
                })
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Section {
                Button(action: { }, label: {
                    SettingRow(
                        icon: "lock.fill",
                        backgroundColor: Color.blue,
                        text: "setting_home_privacy_policy".localized,
                        isButton: true
                    )
                })
                
                Button(action: { URLManager.Setting.showTermsAndConditions() }, label: {
                    SettingRow(
                        icon: "hand.raised.fill",
                        backgroundColor: Color.blue,
                        text: "setting_home_terms_conditions".localized,
                        isButton: true
                    )
                })
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Section {
                NavigationButton(push: router.pushSettingsDangerZone()) {
                    SettingRow(
                        icon: "trash.fill",
                        backgroundColor: Color.red,
                        text: "setting_home_danger".localized,
                        isButton: false
                    )
                }
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Section {
                Text("setting_home_made_by".localized)
                    .foregroundStyle(Color(uiColor: .label))
                    .font(.semiBoldText16())
                    .frame(maxWidth: .infinity)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
        } // End Form
        .environment(\.defaultMinListRowHeight, 0)
        .scrollIndicators(.hidden)
        .background(SharingViewController(isPresenting: $isSharing) {
            if let langCode = Locale.current.language.languageCode,
               let urlApp = URL(string: "https://apps.apple.com/\(langCode.identifier)/app/cashflow-tracker/id6450913423") {
                let text: String = "setting_home_alert_share_desc".localized
                let av = UIActivityViewController(activityItems: [text, urlApp], applicationActivities: nil)
                
                // For iPad
                if UIDevice.current.userInterfaceIdiom == .pad { av.popoverPresentationController?.sourceView = UIView() }
                
                av.completionWithItemsHandler = { _, _, _, _ in
                    isSharing = false // required for re-open !!!
                }
                
                return av
            } else {
                let text: String = "setting_home_alert_share_desc".localized
                return UIActivityViewController(activityItems: [text], applicationActivities: nil)
            }
        })
        .navigationTitle("setting_home_title".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading ) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(uiColor: .label))
                })
                .padding(.bottom, 8)
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SettingsHomeView()
}
