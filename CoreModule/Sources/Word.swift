//
//  Word.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//
// swiftlint:disable nesting

import Foundation
import TheoKit

// swiftlint:disable:next type_name
public struct Word {
    
    public struct Classic {
        public static let category: String = "word_category".localized
        public static let name: String = "word_name".localized
        public static let price: String = "word_price".localized
        public static let typeOfTransaction: String = "word_typeOfTransaction".localized
        public static let typeOfContribution: String = "word_typeOfContribution".localized
        public static let date: String = "word_date".localized
        public static let recommended: String = "word_recommended".localized
        public static let expense: String = "word_expense".localized
        public static let income: String = "word_income".localized
        public static let dayOfAutomation: String = "word_dayOfAutomation".localized
        public static let initialAmount: String = "word_initialAmount".localized
        public static let amountToReach: String = "word_amountToReach".localized
        public static let finalTargetDate: String = "word_finalTargetDate".localized
        public static let startTargetDate: String = "word_startTargetDate".localized
        public static let edit: String = "word_edit".localized
        public static let create: String = "word_create".localized
        public static let senderAccount: String = "word_senderAccount".localized
        public static let receiverAccount: String = "word_receiverAccount".localized
        public static let subscriptionFuturDate: String = "word_subscriptionFuturDate".localized
        public static let frequency: String = "word_frequency".localized
        public static let received: String = "word_received".localized
        public static let sent: String = "word_sent".localized
        public static let retry: String = "word_retry".localized
        public static let add: String = "word_add".localized
        public static let enable: String = "word_enable".localized
        public static let light: String = "word_light".localized
        public static let dark: String = "word_dark".localized
        public static let system: String = "word_system".localized
        public static let note: String = "word_note".localized
        public static let budget: String = "word_budget".localized
        public static let maxAmount: String = "word_maxAmount".localized
        public static let currentAmount: String = "word_currentAmount".localized
        public static let amount: String = "word_amount".localized
        public static let `continue`: String = "word_continue".localized
        public static let notifications: String = "word_notifications".localized
        public static let days: String = "word_days".localized
        public static let disconnect: String = "word_disconnect".localized
        public static let delete: String = "word_delete".localized
        public static let deleteAccount: String = "word_delete_account".localized
        public static let statistics: String = "word_statistics".localized
        public static let remaining: String = "word_remaining".localized
        public static let contributed: String = "word_contributed".localized
        public static let finalTarget: String = "word_finalTarget".localized
        public static let monthlyTarget: String = "word_monthlyTarget".localized
        public static let contributedThisMonth: String = "word_contributedThisMonth".localized
        public static let startDate: String = "word_startDate".localized
        public static let daysElapsed: String = "word_daysElapsed".localized
        public static let daysRemaining: String = "word_daysRemaining".localized
        public static let endDate: String = "word_endDate".localized
    }
    
    public struct AppIntent {
        public static let createTransaction: String = "appIntent_createTransaction".localized
    }
    
    public struct Main {
        public static let transaction: String = "word_transaction".localized
        public static let transactions: String = "word_transactions".localized
        public static let subscription: String = "word_subscription".localized
        public static let subscriptions: String = "word_subscriptions".localized
        public static let savingsPlan: String = "word_savingsplan".localized
        public static let savingsPlans: String = "word_savingsplans".localized
        public static let transfer: String = "word_transfer".localized
        public static let transfers: String = "word_transfers".localized
        public static let savingsAccount: String = "word_savings_account".localized
        public static let savingsAccounts: String = "word_savings_accounts".localized
        public static let creditCard: String = "word_creditcard".localized
        public static let creditCards: String = "word_creditcards".localized
    }
    
    public struct Preposition {
        public static let to: String = "word_preposition_to".localized
        public static let from: String = "word_preposition_from".localized
    }
    
    public struct Temporality {
        public static let today: String = "temporality_today".localized
        public static let yesterday: String = "temporality_yesterday".localized
        public static let tomorrow: String = "temporality_tomorrow".localized
        public static let twoDaysAgo: String = "temporality_two_days_ago".localized
        public static let inTwoDays: String = "temporality_in_two_days".localized
        public static let week: String = "temporality_week".localized
        public static let month: String = "temporality_month".localized
        public static let year: String = "temporality_year".localized
        public static let thisWeek: String = "temporality_this_week".localized
        public static let lastWeek: String = "temporality_last_week".localized
        public static let thisMonth: String = "temporality_this_month".localized
        public static let lastMonth: String = "temporality_last_month".localized
        public static let thisYear: String = "temporality_this_year".localized
        public static let lastYear: String = "temporality_last_year".localized
    }
    
    public struct Create {
        public static let addCategory: String = "create_add_category".localized
    }
    
    public struct Sync {
        public static let continueWithoutData: String = "sync_continue_without_data".localized
        public static let sorryMessage: String = "sync_sorry_message".localized
        public static let fetching: String = "sync_fetching".localized
    }
    
    public struct Frequency {
        public static let weekly: String = "frequency_weekly".localized
        public static let monthly: String = "frequency_monthly".localized
        public static let yearly: String = "frequency_yearly".localized
    }
    
    public struct Title {
        public struct Account {
            public static let new: String = "title_new_account".localized
            public static let update: String = "title_update_account".localized
        }
        public struct Transaction {
            public static let new: String = "title_new_transaction".localized
            public static let update: String = "title_update_transaction".localized
            public static let home: String = "title_home_transactions".localized
        }
        public struct Transfer {
            public static let new: String = "title_new_transfer".localized
        }
        public struct Subscription {
            public static let new: String = "title_new_subscription".localized
            public static let update: String = "title_update_subscription".localized
            public static let home: String = "title_home_subscriptions".localized
        }
        public struct SavingsPlan {
            public static let new: String = "title_new_savingsPlan".localized
            public static let update: String = "title_update_savingsPlan".localized
            public static let home: String = "title_home_savingsPlans".localized
        }
        public struct Budget {
            public static let new: String = "title_new_budget".localized
        }
        public struct CreditCard {
            public static let new: String = "title_new_creditcard".localized
        }
        public struct Setting {
            public static let general: String = "title_setting_general".localized
            public static let security: String = "title_setting_security".localized
            public static let display: String = "title_setting_display".localized
            public static let credits: String = "title_setting_credits".localized
        }
    }
    
    public struct Empty {
        public struct Account {
            public static let desc: String = "empty_accounts_desc".localized
            public static let create: String = "empty_accounts_create".localized
        }
        public struct Transaction {
            public static let desc: String = "empty_transactions_desc".localized
            public static let create: String = "empty_transactions_create".localized
        }
        public struct Subscription {
            public static let desc: String = "empty_subscriptions_desc".localized
            public static let create: String = "empty_subscriptions_create".localized
        }
        public struct SavingsPlan {
            public static let desc: String = "empty_savingsPlans_desc".localized
            public static let create: String = "empty_savingsPlans_create".localized
        }
        public struct Contribution {
            public static let desc: String = "empty_contributions_desc".localized
        }
        public struct SavingsAccount {
            public static let desc: String = "empty_savingsAccounts_desc".localized
            public static let create: String = "empty_savingsAccounts_create".localized
        }
    }
    
    public struct Successful {
        public struct Transaction {
            public static func title(type: SuccessfulType) -> String {
                return "successful_transaction_\(type.rawValue)_title".localized
            }
            public static func description(type: SuccessfulType) -> String {
                return "successful_transaction_\(type.rawValue)_desc".localized
            }
        }
        public struct Transfer {
            public static func title(type: SuccessfulType) -> String {
                return "successful_transfer_\(type.rawValue)_title".localized
            }
            public static func description(type: SuccessfulType) -> String {
                return "successful_transfer_\(type.rawValue)_desc".localized
            }
        }
        public struct SavingsPlan {
            public static func title(type: SuccessfulType) -> String {
                return "successful_savingsplan_\(type.rawValue)_title".localized
            }
            public static func description(type: SuccessfulType) -> String {
                return "successful_savingsplan_\(type.rawValue)_desc".localized
            }
        }
        public struct Contribution {
            public static func title(type: SuccessfulType) -> String {
                return "successful_contribution_\(type.rawValue)_title".localized
            }
            public static func description(type: SuccessfulType) -> String {
                return "successful_contribution_\(type.rawValue)_desc".localized
            }
        }
        public struct Subscription {
            public static func title(type: SuccessfulType) -> String {
                return "successful_subscription_\(type.rawValue)_title".localized
            }
            public static func description(type: SuccessfulType) -> String {
                return "successful_subscription_\(type.rawValue)_desc".localized
            }
        }
    }
    
    struct Delete {
        struct Transaction {
            static let title: String = "delete_transaction_title".localized
            static let expenseMessage: String = "delete_transaction_expense_message".localized
            static let incomeMessage: String = "delete_transaction_income_message".localized
        }
        struct Subscription {
            static let title: String = "delete_subscription_title".localized
            static let message: String = "delete_subscription_message".localized
        }
        struct Contribution {
            static let title: String = "delete_contribution_title".localized
            static let message: String = "delete_contribution_message".localized
        }
    }
    
    public struct Setting {
        public struct General {
            public static let hapticFeedback: String = "setting_general_haptic_feedback".localized
        }
        public struct Security {
            public static let description: String = "setting_security_description".localized
            public static let securityPlus: String = "setting_security_plus".localized
            public static let securityPlusDescription: String = "setting_security_plus_description".localized
        }
        public struct Display {
            public static let homeScreen: String = "setting_display_displayed_home_screen".localized
            public static let nbrSubscriptions: String = "setting_display_nbr_subscriptions".localized
            public static let nbrSavingsPlans: String = "setting_display_nbr_savingsplans".localized
            public static let nbrTransactions: String = "setting_display_nbr_transactions".localized
        }
        public struct Appearance {
            public static let appIcons: String = "setting_appearence_app_icons".localized
            public static let tintColor: String = "setting_appearence_tint_color".localized
        }
        public struct Credits {
            public static let founders: String = "setting_credits_founders".localized
            public static let designers: String = "setting_credits_designers".localized
            public static let licences: String = "setting_credits_licences".localized
        }
        public struct ApplePay {
            public static let addCategory: String = "setting_applepay_addcategory".localized
            public static let footer: String = "setting_applepay_footer".localized
        }
    }
    
    public struct Paywall {
        public static let lifetime: String = "paywall_lifetime".localized
        public struct SavingsAccount {
            public static let desc: String = "paywall_savingsaccounts_desc".localized
        }
        public struct CreditCard {
            public static let desc: String = "paywall_creditcards_desc".localized
        }
    }
    
    public struct CreditCard {
        public static let expire: String = "creditcard_expire".localized
        public static let numbers: String = "creditcard_numbers".localized
        public static let holder: String = "creditcard_holder".localized
        public static let date: String = "creditcard_date".localized
        public static let cvv: String = "creditcard_cvv".localized
        public static let limit: String = "creditcard_limit".localized
        public static let security: String = "creditcard_security".localized
        public static let maxCard: String = "creditcard_maxCard".localized
        public static let maxCardMessage: String = "creditcard_maxCard_message".localized
        public static let deleteTitle: String = "creditcard_delete_title".localized
    }
    
    public struct SavingsAccount {
        public static let totalSavings: String = "savings_account_total_savings".localized
    }
    
    public struct WhatsNew {
        public static let title: String = "whatsnew_title".localized
        public static let userInterfaceTitle: String = "whatsnew_ui_title".localized
        public static let userInterface: String = "whatsnew_ui".localized
        
        public static let stats: String = "whatsnew_stats".localized
        public static let creditcard: String = "whatsnew_creditcard".localized
        public static let applePayTitle: String = "whatsnew_applepay_title".localized
        public static let applePay: String = "whatsnew_applepay".localized
        public static let subscription: String = "whatsnew_subscription".localized
    }
    
    public struct Tips {
        public static let howToDo: String = "tip_how_to_do".localized
        public static let alreadyHaveShortcut: String = "tip_already_have_shortcut".localized
        public struct ApplePay {
            public static let descOne: String = "tip_applepay_desc_one".localized
            public static let descTwo: String = "tip_applepay_desc_two".localized
        }
    }
    
    public struct Notifications {
        public static let daysBefore: String = "notifications_day_before".localized
        public static let footer: String = "notifications_footer".localized
        public static let willRemoved: String = "notifications_will_removed".localized
        public static let willAdded: String = "notifications_will_added".localized
    }
    
    public struct Statistics {
        public static let total: String = "statistics_total".localized
        public static let totalExpenses: String = "statistics_total_expenses".localized
        public static let totalIncomes: String = "statistics_total_incomes".localized
        public static let totalExpensesByMonth: String = "statistics_total_expenses_by_month".localized
        public static let totalIncomesByMonth: String = "statistics_total_incomes_by_month".localized
        public static let totalExpensesByWeek: String = "statistics_total_expenses_by_week".localized
        public static let totalIncomesByWeek: String = "statistics_total_incomes_by_week".localized
        public static let withSavings: String = "statistics_with_savings".localized
    }
    
}
