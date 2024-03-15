//
//  AutomationsHomeView.swift
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

struct AutomationsHomeView: View {
    
    // Builder
    @ObservedObject var account: Account
    
    // Environement
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    // String variables
    @State private var searchText: String = ""
        
    // Boolean variables
    @State private var showAddAutomation: Bool = false
    
    // State or Binding Orientation
    @State private var orientation = UIDeviceOrientation.unknown
    
    // Computed var
    private var searchResults: [Automation] {
        if searchText.isEmpty {
            return account.automations
        } else { //Searching
            let automationsFilterByTitle = account.automations.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            let automationsFilterByDate = account.automations.filter { HelperManager().formattedDateWithDayMonthYear(date: $0.date) .localizedCaseInsensitiveContains(searchText) }
            
            if automationsFilterByTitle.isEmpty {
                return automationsFilterByDate
            } else {
                return automationsFilterByTitle
            }
        }
    }
    
    public var automationsByMonth: [Date: [Automation]] {
        var arrayDate: [Date] = []
        var finalDict: [Date : [Automation]] = [:]
        
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
            if account.automations.count != 0 && searchResults.count != 0  {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(automationsByMonth.sorted(by: { $0.key < $1.key }), id: \.key) { month, automations in
                            DetailOfExpensesAndIncomesByMonth(
                                month: month,
                                amountOfExpenses: AutomationManager().amountExpensesByMonth(month: month, automations: automations),
                                amountOfIncomes: AutomationManager().amountIncomesByMonth(month: month, automations: automations)
                            )
                            ForEach(automations, id: \.self) { automation in
                                CellAutomationView(automation: automation)
                            }
                        }
                    }
                } //End ScrollView
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(uiColor: .label))
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {  }, label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
//        .sheet(isPresented: $showAddAutomation) { AddAutomationsView() } //TODO: REACTIVER
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
    AutomationsHomeView(account: Account.preview)
}
