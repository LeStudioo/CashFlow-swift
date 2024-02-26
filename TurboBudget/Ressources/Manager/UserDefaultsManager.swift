//
//  UserDefaultsManager.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//

//import Foundation
//
//class UserDefaultsManager: ObservableObject {
//    static let shared = UserDefaultsManager()
//
//    //Color
//    @Published var colorSelected: String {
//        didSet { UserDefaults.standard.set(colorSelected, forKey: "colorSelected") }
//    }
//    
//    //Pref Account
//    @Published var accountID: String {
//        didSet { UserDefaults.standard.set(accountID, forKey: "accountID") }
//    }
//    
//    //Setting - General
//    @Published var hapticFeedback: Bool {
//        didSet { UserDefaults.standard.set(hapticFeedback, forKey: "hapticFeedback") }
//    }
//    
//    //Setting - Display - Home Screen
//    @Published var isSavingPlansDisplayedHomeScreen: Bool {
//        didSet { UserDefaults.standard.set(isSavingPlansDisplayedHomeScreen, forKey: "isSavingPlansDisplayedHomeScreen") }
//    }
//    @Published var isAutomationsDisplayedHomeScreen: Bool {
//        didSet { UserDefaults.standard.set(isAutomationsDisplayedHomeScreen, forKey: "isAutomationsDisplayedHomeScreen") }
//    }
//    @Published var isRecentTransactionsDisplayedHomeScreen: Bool {
//        didSet { UserDefaults.standard.set(isRecentTransactionsDisplayedHomeScreen, forKey: "isRecentTransactionsDisplayedHomeScreen") }
//    }
//    @Published var numberOfAutomationsDisplayedInHomeScreen: Int {
//        didSet { UserDefaults.standard.set(numberOfAutomationsDisplayedInHomeScreen, forKey: "numberOfAutomationsDisplayedInHomeScreen") }
//    }
//    @Published var numberOfSavingPlansDisplayedInHomeScreen: Int {
//        didSet { UserDefaults.standard.set(numberOfSavingPlansDisplayedInHomeScreen, forKey: "numberOfSavingPlansDisplayedInHomeScreen") }
//    }
//    
//    //Setting - Display - Analytics
//    @Published var isExpenseTransactionsChart: Bool {
//        didSet { UserDefaults.standard.set(isExpenseTransactionsChart, forKey: "isExpenseTransactionsChart") }
//    }
//    @Published var isIncomeFromTransactionsChart: Bool {
//        didSet { UserDefaults.standard.set(isIncomeFromTransactionsChart, forKey: "isIncomeFromTransactionsChart") }
//    }
//    @Published var isExpenseTransactionsWithAutomationChart: Bool {
//        didSet { UserDefaults.standard.set(isExpenseTransactionsWithAutomationChart, forKey: "isExpenseTransactionsWithAutomationChart") }
//    }
//    @Published var isIncomeFromTransactionsWithAutomationChart: Bool {
//        didSet { UserDefaults.standard.set(isIncomeFromTransactionsWithAutomationChart, forKey: "isIncomeFromTransactionsWithAutomationChart") }
//    }
//    @Published var orderOfCharts: [String] {
//        didSet { UserDefaults.standard.set(orderOfCharts, forKey: "orderOfCharts") }
//    }
//    
//    //Setting - Security
//    @Published var isFaceIDEnable: Bool {
//        didSet { UserDefaults.standard.set(isFaceIDEnable, forKey: "isFaceIDEnable") }
//    }
//    @Published var isSecurityPlusEnable: Bool {
//        didSet { UserDefaults.standard.set(isSecurityPlusEnable, forKey: "isSecurityPlusEnable") }
//    }
//    
//    //Setting - Account
//    @Published var accountCanBeNegative: Bool {
//        didSet { UserDefaults.standard.set(accountCanBeNegative, forKey: "accountCanBeNegative") }
//    }
//    @Published var blockExpensesIfCardLimitExceeds: Bool {
//        didSet { UserDefaults.standard.set(blockExpensesIfCardLimitExceeds, forKey: "blockExpensesIfCardLimitExceeds") }
//    }
//    @Published var cardLimitPercentage: Double {
//        didSet { UserDefaults.standard.set(cardLimitPercentage, forKey: "cardLimitPercentage") }
//    }
//    
//    //Setting - Transactions
//    @Published var recentTransactionNumber: Int {
//        didSet { UserDefaults.standard.set(recentTransactionNumber, forKey: "recentTransactionNumber") }
//    }
//    
//    @Published var automatedArchivedTransaction: Bool {
//        didSet { UserDefaults.standard.set(automatedArchivedTransaction, forKey: "automatedArchivedTransaction") }
//    }
//    @Published var numberOfDayForArchivedTransaction: Int {
//        didSet { UserDefaults.standard.set(numberOfDayForArchivedTransaction, forKey: "numberOfDayForArchivedTransaction") }
//    }
//    
//    //Setting - Saving Plan
//    @Published var automatedArchivedSavingPlan: Bool {
//        didSet { UserDefaults.standard.set(automatedArchivedSavingPlan, forKey: "automatedArchivedSavingPlan") }
//    }
//    @Published var numberOfDayForArchivedSavingPlan: Int {
//        didSet { UserDefaults.standard.set(numberOfDayForArchivedSavingPlan, forKey: "numberOfDayForArchivedSavingPlan") }
//    }
//    
//    //Setting - Budgets
//    @Published var blockExpensesIfBudgetAmountExceeds: Bool {
//        didSet { UserDefaults.standard.set(blockExpensesIfBudgetAmountExceeds, forKey: "blockExpensesIfBudgetAmountExceeds") }
//    }
//    @Published var budgetPercentage: Double {
//        didSet { UserDefaults.standard.set(budgetPercentage, forKey: "budgetPercentage") }
//    }
//    
//    //Setting - Notification
//    @Published var notificationTimeDay: Int {
//        didSet { UserDefaults.standard.set(notificationTimeDay, forKey: "notificationTimeDay") }
//    }
//    @Published var notificationTimeHour: Date {
//        didSet { UserDefaults.standard.set(notificationTimeHour, forKey: "notificationTimeHour") }
//    }
//    
//    //Setting - Financial Advice
//    @Published var isStepsEnbaleForAllSavingsPlans: Bool { //FA5
//        didSet { UserDefaults.standard.set(isStepsEnbaleForAllSavingsPlans, forKey: "isStepsEnbaleForAllSavingsPlans") }
//    }
//    @Published var isNoSpendChallengeEnbale: Bool { //FA5
//        didSet { UserDefaults.standard.set(isNoSpendChallengeEnbale, forKey: "isNoSpendChallengeEnbale") }
//    }
//    @Published var isBuyingQualityEnable: Bool { //FA6
//        didSet { UserDefaults.standard.set(isBuyingQualityEnable, forKey: "isBuyingQualityEnable") }
//    }
//    @Published var isPayingYourselfFirstEnable: Bool { //FA7
//        didSet { UserDefaults.standard.set(isPayingYourselfFirstEnable, forKey: "isPayingYourselfFirstEnable") }
//    }
//    @Published var isSearchDuplicateEnable: Bool { //FA9
//        didSet { UserDefaults.standard.set(isSearchDuplicateEnable, forKey: "isSearchDuplicateEnable") }
//    }
//    
//    //Init
//    init() {        
//        //Setting - General
//        hapticFeedback = UserDefaults.standard.bool(forKey: "hapticFeedback")
//        
//        //Setting - Display - Home Screen
//        isSavingPlansDisplayedHomeScreen = UserDefaults.standard.bool(forKey: "isSavingPlansDisplayedHomeScreen")
//        isAutomationsDisplayedHomeScreen = UserDefaults.standard.bool(forKey: "isAutomationsDisplayedHomeScreen")
//        isRecentTransactionsDisplayedHomeScreen = UserDefaults.standard.bool(forKey: "isRecentTransactionsDisplayedHomeScreen")
//        numberOfAutomationsDisplayedInHomeScreen = UserDefaults.standard.integer(forKey: "numberOfAutomationsDisplayedInHomeScreen")
//        numberOfSavingPlansDisplayedInHomeScreen = UserDefaults.standard.integer(forKey: "numberOfSavingPlansDisplayedInHomeScreen")
//        
//        //Setting - Display - Analytics
//        isExpenseTransactionsChart = UserDefaults.standard.bool(forKey: "isExpenseTransactionsChart")
//        isIncomeFromTransactionsChart = UserDefaults.standard.bool(forKey: "isIncomeFromTransactionsChart")
//        isExpenseTransactionsWithAutomationChart = UserDefaults.standard.bool(forKey: "isExpenseTransactionsWithAutomationChart")
//        isIncomeFromTransactionsWithAutomationChart = UserDefaults.standard.bool(forKey: "isIncomeFromTransactionsWithAutomationChart")
//        if let savedArray = UserDefaults.standard.array(forKey: "orderOfCharts") as? [String] {
//            orderOfCharts = savedArray
//        } else {
//            let charts = ["word_incomes".localized,
//                          "word_expenses".localized,
//                          "word_automations_incomes".localized,
//                          "word_automations_expenses".localized]
//            orderOfCharts = charts
//        }
//        
//        //Setting - Security
//        isFaceIDEnable = UserDefaults.standard.bool(forKey: "isFaceIDEnable")
//        isSecurityPlusEnable = UserDefaults.standard.bool(forKey: "isSecurityPlusEnable")
//        
//        //Setting - Account
//        accountCanBeNegative = UserDefaults.standard.bool(forKey: "accountCanBeNegative")
//        blockExpensesIfCardLimitExceeds = UserDefaults.standard.bool(forKey: "blockExpensesIfCardLimitExceeds")
//        cardLimitPercentage = UserDefaults.standard.double(forKey: "cardLimitPercentage")
//        
//        //Setting - Transactions
//        recentTransactionNumber = UserDefaults.standard.integer(forKey: "recentTransactionNumber")
//        automatedArchivedTransaction = UserDefaults.standard.bool(forKey: "automatedArchivedTransaction")
//        numberOfDayForArchivedTransaction = UserDefaults.standard.integer(forKey: "numberOfDayForArchivedTransaction")
//        
//        //Setting - Saving Plan
//        automatedArchivedSavingPlan = UserDefaults.standard.bool(forKey: "automatedArchivedSavingPlan")
//        numberOfDayForArchivedSavingPlan = UserDefaults.standard.integer(forKey: "numberOfDayForArchivedSavingPlan")
//        
//        //Setting - Budgets
//        blockExpensesIfBudgetAmountExceeds = UserDefaults.standard.bool(forKey: "blockExpensesIfBudgetAmountExceeds")
//        budgetPercentage = UserDefaults.standard.double(forKey: "budgetPercentage")
//        
//        //Setting - Notification
//        notificationTimeDay = UserDefaults.standard.integer(forKey: "notificationTimeDay")
//        if let savedDate = UserDefaults.standard.object(forKey: "notificationTimeHour") as? Date {
//            notificationTimeHour = savedDate
//        } else { notificationTimeHour = .now }
//        
//        //Setting - Financial Advice
//        /* FA4 */ isStepsEnbaleForAllSavingsPlans = UserDefaults.standard.bool(forKey: "isStepsEnbaleForAllSavingsPlans")
//        /* FA5 */ isNoSpendChallengeEnbale = UserDefaults.standard.bool(forKey: "isNoSpendChallengeEnbale")
//        /* FA6 */ isBuyingQualityEnable = UserDefaults.standard.bool(forKey: "isBuyingQualityEnable")
//        /* FA7 */ isPayingYourselfFirstEnable = UserDefaults.standard.bool(forKey: "isPayingYourselfFirstEnable")
//        /* FA9 */ isSearchDuplicateEnable = UserDefaults.standard.bool(forKey: "isSearchDuplicateEnable")
//        
//        //Color
//        colorSelected = UserDefaults.standard.string(forKey: "colorSelected") ?? "111"
//        
//        //account
//        accountID = UserDefaults.standard.string(forKey: "accountID") ?? ""
//    }
//}
