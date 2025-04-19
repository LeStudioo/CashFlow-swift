//
//  SettingsHomeView.swift
//  CashFlow
//
//  Created by KaayZenn on 24/02/2024.
//

import SwiftUI
import AlertKit
import NavigationKit

struct SettingsHomeView: View {
    
    // Environment
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var userStore: UserStore
    @Environment(\.dismiss) private var dismiss
    
    // EnvironementObject
    @EnvironmentObject var store: PurchasesManager
    
    // Boolean variables
    @State private var isSharing: Bool = false
    
    // MARK: - body
    var body: some View {
        Form {
#if DEBUG
            Section {
                NavigationButton(
                    route: .push,
                    destination: AppDestination.settings(.debug)
                ) {
                    SettingRow(
                        icon: "hammer.fill",
                        backgroundColor: Color.blue,
                        text: "Debug",
                        isButton: false
                    )
                }
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
#endif
            Section {
                NavigationButton(
                    route: .sheet,
                    destination: AppDestination.shared(.paywall)
                ) {
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
                NavigationButton(
                    route: .push,
                    destination: AppDestination.settings(.general)
                ) {
                    SettingRow(
                        icon: "gearshape.fill",
                        backgroundColor: Color.gray,
                        text: Word.Title.Setting.general,
                        isButton: false
                    )
                }
                
                NavigationButton(
                    route: .push,
                    destination: AppDestination.settings(.security)
                ) {
                    SettingRow(
                        icon: "lock.fill",
                        backgroundColor: Color.green,
                        text: Word.Title.Setting.security,
                        isButton: false
                    )
                }
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Section {
                NavigationButton(
                    route: .push,
                    destination: AppDestination.settings(.appearance)
                ) {
                    SettingRow(
                        icon: "sun.max.fill",
                        backgroundColor: Color.indigo,
                        text: "setting_home_appearance".localized,
                        isButton: false
                    )
                }
                
                NavigationButton(
                    route: .push,
                    destination: AppDestination.settings(.display)
                ) {
                    SettingRow(
                        icon: "apps.iphone",
                        backgroundColor: Color.blue,
                        text: Word.Title.Setting.display,
                        isButton: false
                    )
                }
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Section {
                NavigationButton(
                    route: .push,
                    destination: AppDestination.settings(.subscription)
                ) {
                    SettingRow(
                        icon: "clock.arrow.circlepath",
                        backgroundColor: Color.red,
                        text: Word.Main.subscription,
                        isButton: false
                    )
                }
                
                NavigationButton(
                    route: store.isCashFlowPro ? .push : .sheet,
                    destination: store.isCashFlowPro ? AppDestination.settings(.applePay) : AppDestination.shared(.paywall)
                ) {
                    SettingRow(
                        icon: "creditcard.fill",
                        backgroundColor: Color.purple,
                        text: "Apple Pay",
                        isButton: store.isCashFlowPro ? false : true
                    )
                }
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Section {
                Button(action: { URLManager.openURL(url: URLManager.PredefinedURL.Tutos.importFromApplePay.rawValue) }, label: {
                    SettingRow(
                        icon: "creditcard.fill",
                        backgroundColor: Color.purple,
                        text: "settings_applepay_shortcut_button".localized,
                        isButton: true
                    )
                })
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
                NavigationButton(
                    route: .push,
                    destination: AppDestination.settings(.credits)
                ) {
                    SettingRow(
                        icon: "person.fill",
                        backgroundColor: Color.indigo,
                        text: Word.Title.Setting.credits,
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
                Button { alertManager.signOut(dismiss: dismiss) } label: {
                    SettingRow(
                        icon: "rectangle.portrait.and.arrow.right.fill",
                        backgroundColor: Color.red,
                        text: Word.Classic.disconnect,
                        isButton: true
                    )
                }
                Button { alertManager.deleteUser(dismiss: dismiss) } label: {
                    SettingRow(
                        icon: "trash.fill",
                        backgroundColor: Color.red,
                        text: Word.Classic.deleteAccount,
                        isButton: true
                    )
                }
            }
            .listRowInsets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            
            Section {
                Group {
                    Text("v\(Bundle.main.releaseVersionNumber ?? "")")
                        .foregroundStyle(Color.text)
                        .font(.semiBoldText16())
                    
                    Button(action: { URLManager.Setting.showTermsAndConditions() }, label: {
                        Label("setting_home_terms_conditions".localized, systemImage: "hand.raised.fill")
                    })
                    
                    Button(action: { }, label: {
                        Label("setting_home_privacy_policy".localized, systemImage: "lock.fill")
                    })
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            
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
            ToolbarDismissPushButton()
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SettingsHomeView()
}
