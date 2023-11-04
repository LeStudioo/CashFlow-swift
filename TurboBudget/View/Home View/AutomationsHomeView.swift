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

    //Custom type
    @Binding var account: Account?
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared

    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding String
    @State private var searchText: String = ""

    //State or Binding Int, Float and Double

    //State or Binding Bool
    @State private var showAddAutomation: Bool = false
    
    //State or Binding Orientation
    @State private var orientation = UIDeviceOrientation.unknown

	//Enum
    @State private var filterAutomation: FilterForAutomation = .day
	
	//Computed var
    private var searchResults: [Automation] {
        if let account {
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
        } else { return [] }
    }
    
    public var automationsByDay: [Date: [Automation]] {
        var arrayDate: [Date] = []
        var finalDict: [Date : [Automation]] = [:]
        
        for automation in searchResults {
            let day = Calendar.current.dateComponents([.day, .month, .year], from: automation.date)
            let finalDate = Calendar.current.date(from: day)
            if let finalDate {
                if !arrayDate.contains(finalDate) { arrayDate.append(finalDate) }
            }
        }
        
        for date in arrayDate {
            finalDict[date] = []
            
            for automation in searchResults {
                let day = Calendar.current.dateComponents([.day, .month, .year], from: automation.date)
                let finalDate = Calendar.current.date(from: day)
                if let finalDate {
                    if Calendar.current.isDate(date, inSameDayAs: finalDate) && Calendar.current.isDate(date, equalTo: finalDate, toGranularity: .month) {
                        finalDict[date]?.append(automation)
                    }
                }
            }
        }
        return finalDict
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
    
    var systemImageDay: String {
        return String(Date().currentDayOfMonth()) + ".circle"
    }
    
    //Binding update
    @Binding var update: Bool
    
    //MARK: - Body
    var body: some View {
        if let account {
            VStack(spacing: 0) {
                if account.automations.count != 0 && searchResults.count != 0  {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            if filterAutomation == .day {
                                ForEach(automationsByDay.sorted(by: { $0.key < $1.key }), id: \.key) { day, automations in
                                    if automations.count != 0 {
                                        DetailOfExpensesAndIncomesByDay(
                                            day: day,
                                            amountOfExpenses: AutomationManager().amountExpensesByDay(day: day, automations: automations),
                                            amountOfIncomes: AutomationManager().amountIncomesByDay(day: day, automations: automations)
                                        )
                                        ForEach(automations, id: \.self) { automation in
                                            if let transaction = automation.automationToTransaction {
                                                CellTransactionForAutomationView(transaction: transaction, update: $update)
                                            }
                                        }
                                    }
                                }
                            } else if filterAutomation == .month {
                                ForEach(automationsByMonth.sorted(by: { $0.key < $1.key }), id: \.key) { month, automations in
                                    DetailOfExpensesAndIncomesByMonth(
                                        month: month,
                                        amountOfExpenses: AutomationManager().amountExpensesByMonth(month: month, automations: automations),
                                        amountOfIncomes: AutomationManager().amountIncomesByMonth(month: month, automations: automations)
                                    )
                                    ForEach(automations, id: \.self) { automation in
                                        if let transaction = automation.automationToTransaction {
                                            CellTransactionForAutomationView(transaction: transaction, update: $update)
                                        }
                                    }
                                }
                            }
                        }
                    } //End ScrollView
                } else {
                    ErrorView(
                        searchResultsCount: searchResults.count,
                        searchText: searchText,
                        image: "NoAutomation",
                        text: NSLocalizedString("automations_home_no_auto", comment: "")
                    )
                }
            }
            .navigationTitle(NSLocalizedString("word_automations", comment: ""))
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .searchable(text: $searchText.animation(), prompt: NSLocalizedString("word_search", comment: ""))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }, label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.colorLabel)
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        Button(action: { showAddAutomation.toggle() }, label: { Label(NSLocalizedString("word_add", comment: ""), systemImage: "plus") })
                        Menu(content: {
                            Button(action: { filterAutomation = .day }, label: { Label(NSLocalizedString("word_day", comment: ""), systemImage: systemImageDay) })
                            Button(action: { filterAutomation = .month }, label: { Label(NSLocalizedString("word_month", comment: ""), systemImage: "calendar") })
                        }, label: {
                            Label(NSLocalizedString("word_filter", comment: ""), systemImage: "slider.horizontal.3")
                        })
                    }, label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.colorLabel)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                    })
                }
            }
            .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showAddAutomation, onDismiss: { update.toggle() }) {
                AddAutomationsView(account: $account)
            }
            .onAppear { getOrientationOnAppear() }
        }
    }//END body

    //MARK: Fonctions
    func getOrientationOnAppear() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            orientation = UIDeviceOrientation.landscapeLeft
        } else { orientation = UIDeviceOrientation.portrait }
    }
    
}//END struct

//MARK: - Preview
struct AutomationsView_Previews: PreviewProvider {
    
    @State static var previewBool: Bool = false
    @State static var previewAccount: Account? = previewAccount1()
    
    static var previews: some View {
        AutomationsHomeView(account: $previewAccount, update: $previewBool)
    }
}
