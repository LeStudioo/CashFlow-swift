//
//  SubscriptionHomeView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

enum FilterForAutomation: Int, CaseIterable {
    case day, month
}

struct SubscriptionHomeView: View {
    
    // Environement
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var subscriptionRepository: SubscriptionRepository
    @EnvironmentObject private var automationRepo: AutomationRepositoryOld
    @Environment(\.dismiss) private var dismiss
    
    // String variables
    @State private var searchText: String = ""
        
    // Boolean variables
    @State private var showAddAutomation: Bool = false
    
    // State or Binding Orientation
    @State private var orientation = UIDeviceOrientation.unknown
    
    // Computed var
    private var searchResults: [SubscriptionModel] {
        if searchText.isEmpty {
            return subscriptionRepository.subscriptions
        } else { //Searching
            let automationsFilterByTitle = subscriptionRepository.subscriptions
                .filter { $0.name?.localizedStandardContains(searchText) ?? false }
            
            let automationsFilterByDate = subscriptionRepository.subscriptions
                .filter { HelperManager().formattedDateWithDayMonthYear(date: $0.date).localizedStandardContains(searchText) }
            
            if automationsFilterByTitle.isEmpty {
                return automationsFilterByDate
            } else {
                return automationsFilterByTitle
            }
        }
    }
    
    public var automationsByMonth: [Date: [SubscriptionModel]] {
        var arrayDate: [Date] = []
        var finalDict: [Date : [SubscriptionModel]] = [:]
        
        for automation in searchResults {
            let month = Calendar.current.dateComponents([.month, .year], from: automation.date)
            let finalDate = Calendar.current.date(from: month)
            if let finalDate {
                if !arrayDate.contains(finalDate) { arrayDate.append(finalDate) }
            }
        }
        
        for date in arrayDate {
            finalDict[date] = []
            
            for automation in searchResults {
                let month = Calendar.current.dateComponents([.month, .year], from: automation.date)
                let finalDate = Calendar.current.date(from: month)
                if let finalDate {
                    if Calendar.current.isDate(date, equalTo: finalDate, toGranularity: .month) && Calendar.current.isDate(date, equalTo: finalDate, toGranularity: .year) {
                        finalDict[date]?.append(automation)
                    }
                }
            }
        }
        return finalDict
    }
    
    // MARK: - body
    var body: some View {
        VStack(spacing: 0) {
            if !subscriptionRepository.subscriptions.isEmpty && searchResults.count != 0  {
                List {
                    ForEach(automationsByMonth.sorted(by: { $0.key < $1.key }), id: \.key) { month, subscriptions in
                        Section {
                            ForEach(subscriptions, id: \.self) { subscription in
                                SubscriptionRow(subscription: subscription)
                                    .padding(.horizontal)
                            }
                        } header: {
//                            DetailOfExpensesAndIncomesByMonth(
//                                month: month,
//                                amountOfExpenses: AutomationManager().amountExpensesByMonth(month: month, automations: automations),
//                                amountOfIncomes: AutomationManager().amountIncomesByMonth(month: month, automations: automations)
//                            )
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                    .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
                } // End List
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(Color.background.edgesIgnoringSafeArea(.all))
                .animation(.smooth, value: automationRepo.automations.count)
            } else {
                ErrorView(
                    searchResultsCount: searchResults.count,
                    searchText: searchText,
                    image: "NoAutomation",
                    text: "automations_home_no_auto".localized
                )
            }
        }
        .navigationTitle("word_automations".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationButton(present: router.presentCreateAutomation()) {
                    Image(systemName: "plus")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onAppear { getOrientationOnAppear() }
    } // End body
    
    // MARK: - Fonctions
    func getOrientationOnAppear() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            orientation = UIDeviceOrientation.landscapeLeft
        } else { orientation = UIDeviceOrientation.portrait }
    }
    
} // End struct

// MARK: - Preview
#Preview {
    SubscriptionHomeView()
}
