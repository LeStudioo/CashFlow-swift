//
//  SettingDisplayView.swift
//  CashFlow
//
//  Created by KaayZenn on 12/08/2023.
//
// Localizations 01/10/2023

import Foundation
import SwiftUI
import Setting
import UniformTypeIdentifiers

func settingDisplayView(indexAutomationsNumber: Binding<Int>, indexSavingPlansNumber: Binding<Int>, indexTransactionsNumber: Binding<Int>) -> SettingPage {
    
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    @State var automationsNumber: [String] = ["2", "4", "6"]
    @State var savingPlansNumber: [String] = ["2", "4", "6"]
    
    @State var recentTransactions: [String] = ["5", "6", "7", "8", "9", "10"]
    
    return SettingPage(title: NSLocalizedString("setting_display_title", comment: "")) {
        SettingGroup(header: NSLocalizedString("setting_display_displayed_home_screen", comment: "")) {
            SettingToggle(title: NSLocalizedString("word_savingsplans", comment: ""), isOn: $userDefaultsManager.isSavingPlansDisplayedHomeScreen)
            SettingToggle(title: NSLocalizedString("word_automations", comment: ""), isOn: $userDefaultsManager.isAutomationsDisplayedHomeScreen)
            SettingToggle(title: NSLocalizedString("setting_display_recent_transactions", comment: ""), isOn: $userDefaultsManager.isRecentTransactionsDisplayedHomeScreen)
            
            SettingPicker(title: NSLocalizedString("setting_display_nbr_automations", comment: ""), choices: automationsNumber, selectedIndex: indexAutomationsNumber)
                .pickerDisplayMode(.menu)
            SettingPicker(title: NSLocalizedString("setting_display_nbr_savingsplans", comment: ""), choices: savingPlansNumber, selectedIndex: indexSavingPlansNumber)
                .pickerDisplayMode(.menu)
            SettingPicker(title: NSLocalizedString("setting_display_nbr_transactions", comment: ""), choices: recentTransactions, selectedIndex: indexTransactionsNumber)
                .pickerDisplayMode(.menu)
        }
        
        SettingGroup(header: NSLocalizedString("setting_display_displayed_analytics", comment: "")) {
            SettingToggle(title: NSLocalizedString("word_incomes", comment: ""), isOn: $userDefaultsManager.isIncomeFromTransactionsChart)
            SettingToggle(title: NSLocalizedString("word_expenses", comment: ""), isOn: $userDefaultsManager.isExpenseTransactionsChart)
            SettingToggle(title: NSLocalizedString("word_automations_incomes", comment: ""), isOn: $userDefaultsManager.isIncomeFromTransactionsWithAutomationChart)
            SettingToggle(title: NSLocalizedString("word_automations_expenses", comment: ""), isOn: $userDefaultsManager.isExpenseTransactionsWithAutomationChart)
            SettingPage(title: NSLocalizedString("setting_display_order_charts", comment: "")) {
                SettingCustomView {
                    OrderOfChartsView()
                }
            }
        }
    }
    .previewIcon("apps.iphone", backgroundColor: .blue)
}

struct OrderOfChartsView: View {
    
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    @State var arrayOfCharts: [String] = []
    @State var dragging: String?
    
    var body: some View {
        VStack {
            ForEach(arrayOfCharts, id: \.self) { chart in
                HStack {
                    Text(chart)
                        .font(Font.mediumText16())
                    Spacer()
                    Image(systemName: "line.3.horizontal")
                }
                .padding(12)
                .padding(.vertical)
                .background(Color.colorCell)
                .cornerRadius(15)
                .draggable(chart) {
                    HStack {
                        Text(chart)
                            .font(Font.mediumText16())
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                    }
                    .onAppear { dragging = chart }
                }
                .dropDestination(for: String.self, action: { items, location in
                    return false
                }, isTargeted: { isActive in
                    guard let draggedChart = dragging, isActive, draggedChart != chart else { return }
                    let (source, destination) = (arrayOfCharts.firstIndex(of: draggedChart), arrayOfCharts.firstIndex(of: chart))
                    if let srcIndex = source, let destIndex = destination {
                        withAnimation(.spring()) { arrayOfCharts.move(fromOffsets: IndexSet(integer: srcIndex), toOffset: destIndex) }
                    }
                })
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
        }
        .onAppear { arrayOfCharts = userDefaultsManager.orderOfCharts }
        .onChange(of: arrayOfCharts) { newValue in
            userDefaultsManager.orderOfCharts = newValue
        }
    }
    
}
