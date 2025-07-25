////
////  Word.swift
////  CashFlow
////
////  Created by Theo Sementa on 06/10/2024.
////
//// swiftlint:disable nesting
//
//import Foundation
//
//// swiftlint:disable:next type_name
//struct Word {
//    
//    struct Classic {
//        static let category: String = "word_category".localized
//        static let name: String = "word_name".localized
//        static let price: String = "word_price".localized
//        static let typeOfTransaction: String = "word_typeOfTransaction".localized
//        static let typeOfContribution: String = "word_typeOfContribution".localized
//        static let date: String = "word_date".localized
//        static let recommended: String = "word_recommended".localized
//        static let expense: String = "word_expense".localized
//        static let income: String = "word_income".localized
//        static let dayOfAutomation: String = "word_dayOfAutomation".localized
//        static let initialAmount: String = "word_initialAmount".localized
//        static let amountToReach: String = "word_amountToReach".localized
//        static let finalTargetDate: String = "word_finalTargetDate".localized
//        static let startTargetDate: String = "word_startTargetDate".localized
//        static let edit: String = "word_edit".localized
//        static let create: String = "word_create".localized
//        static let senderAccount: String = "word_senderAccount".localized
//        static let receiverAccount: String = "word_receiverAccount".localized
//        static let subscriptionFuturDate: String = "word_subscriptionFuturDate".localized
//        static let frequency: String = "word_frequency".localized
//        static let received: String = "word_received".localized
//        static let sent: String = "word_sent".localized
//        static let retry: String = "word_retry".localized
//        static let add: String = "word_add".localized
//        static let enable: String = "word_enable".localized
//        static let light: String = "word_light".localized
//        static let dark: String = "word_dark".localized
//        static let system: String = "word_system".localized
//        static let note: String = "word_note".localized
//        static let budget: String = "word_budget".localized
//        static let maxAmount: String = "word_maxAmount".localized
//        static let currentAmount: String = "word_currentAmount".localized
//        static let amount: String = "word_amount".localized
//        static let `continue`: String = "word_continue".localized
//        static let notifications: String = "word_notifications".localized
//        static let days: String = "word_days".localized
//        static let disconnect: String = "word_disconnect".localized
//        static let delete: String = "word_delete".localized
//        static let deleteAccount: String = "word_delete_account".localized
//        static let statistics: String = "word_statistics".localized
//        static let remaining: String = "word_remaining".localized
//        static let contributed: String = "word_contributed".localized
//        static let finalTarget: String = "word_finalTarget".localized
//        static let monthlyTarget: String = "word_monthlyTarget".localized
//        static let contributedThisMonth: String = "word_contributedThisMonth".localized
//        static let startDate: String = "word_startDate".localized
//        static let daysElapsed: String = "word_daysElapsed".localized
//        static let daysRemaining: String = "word_daysRemaining".localized
//        static let endDate: String = "word_endDate".localized
//
//    }
//    
//    struct AppIntent {
//        static let createTransaction: String = "appIntent_createTransaction".localized
//    }
//    
//    struct Main {
//        static let transaction: String = "word_transaction".localized
//        static let transactions: String = "word_transactions".localized
//        static let subscription: String = "word_subscription".localized
//        static let subscriptions: String = "word_subscriptions".localized
//        static let savingsPlan: String = "word_savingsplan".localized
//        static let savingsPlans: String = "word_savingsplans".localized
//        static let transfer: String = "word_transfer".localized
//        static let transfers: String = "word_transfers".localized
//        static let savingsAccount: String = "word_savings_account".localized
//        static let savingsAccounts: String = "word_savings_accounts".localized
//        static let creditCard: String = "word_creditcard".localized
//        static let creditCards: String = "word_creditcards".localized
//    }
//    
//    struct Preposition {
//        static let to: String = "word_preposition_to".localized
//        static let from: String = "word_preposition_from".localized
//    }
//    
//    struct Temporality {
//        static let today: String = "temporality_today".localized
//        static let yesterday: String = "temporality_yesterday".localized
//        static let tomorrow: String = "temporality_tomorrow".localized
//        static let twoDaysAgo: String = "temporality_two_days_ago".localized
//        static let inTwoDays: String = "temporality_in_two_days".localized
//        static let week: String = "temporality_week".localized
//        static let month: String = "temporality_month".localized
//        static let year: String = "temporality_year".localized
//        static let thisWeek: String = "temporality_this_week".localized
//        static let lastWeek: String = "temporality_last_week".localized
//        static let thisMonth: String = "temporality_this_month".localized
//        static let lastMonth: String = "temporality_last_month".localized
//        static let thisYear: String = "temporality_this_year".localized
//        static let lastYear: String = "temporality_last_year".localized
//    }
//    
//    struct Create {
//        static let addCategory: String = "create_add_category".localized
//    }
//    
//    struct Sync {
//        static let continueWithoutData: String = "sync_continue_without_data".localized
//        static let sorryMessage: String = "sync_sorry_message".localized
//        static let fetching: String = "sync_fetching".localized
//    }
//    
//    struct Frequency {
//        static let weekly: String = "frequency_weekly".localized
//        static let monthly: String = "frequency_monthly".localized
//        static let yearly: String = "frequency_yearly".localized
//    }
//    
//    struct Title {
//        struct Account {
//            static let new: String = "title_new_account".localized
//            static let update: String = "title_update_account".localized
//        }
//        struct Transaction {
//            static let new: String = "title_new_transaction".localized
//            static let update: String = "title_update_transaction".localized
//            static let home: String = "title_home_transactions".localized
//        }
//        struct Transfer {
//            static let new: String = "title_new_transfer".localized
//        }
//        struct Subscription {
//            static let new: String = "title_new_subscription".localized
//            static let update: String = "title_update_subscription".localized
//            static let home: String = "title_home_subscriptions".localized
//        }
//        struct SavingsPlan {
//            static let new: String = "title_new_savingsPlan".localized
//            static let update: String = "title_update_savingsPlan".localized
//            static let home: String = "title_home_savingsPlans".localized
//        }
//        struct Budget {
//            static let new: String = "title_new_budget".localized
//        }
//        struct CreditCard {
//            static let new: String = "title_new_creditcard".localized
//        }
//        struct Setting {
//            static let general: String = "title_setting_general".localized
//            static let security: String = "title_setting_security".localized
//            static let display: String = "title_setting_display".localized
//            static let credits: String = "title_setting_credits".localized
//        }
//    }
//    
//    struct Empty {
//        struct Account {
//            static let desc: String = "empty_accounts_desc".localized
//            static let create: String = "empty_accounts_create".localized
//        }
//        struct Transaction {
//            static let desc: String = "empty_transactions_desc".localized
//            static let create: String = "empty_transactions_create".localized
//        }
//        struct Subscription {
//            static let desc: String = "empty_subscriptions_desc".localized
//            static let create: String = "empty_subscriptions_create".localized
//        }
//        struct SavingsPlan {
//            static let desc: String = "empty_savingsPlans_desc".localized
//            static let create: String = "empty_savingsPlans_create".localized
//        }
//        struct Contribution {
//            static let desc: String = "empty_contributions_desc".localized
//        }
//        struct SavingsAccount {
//            static let desc: String = "empty_savingsAccounts_desc".localized
//            static let create: String = "empty_savingsAccounts_create".localized
//        }
//    }
//    
//    struct Successful {
//        struct Transaction {
//            static func title(type: SuccessfulType) -> String {
//                return "successful_transaction_\(type.rawValue)_title".localized
//            }
//            static func description(type: SuccessfulType) -> String {
//                return "successful_transaction_\(type.rawValue)_desc".localized
//            }
//        }
//        struct Transfer {
//            static func title(type: SuccessfulType) -> String {
//                return "successful_transfer_\(type.rawValue)_title".localized
//            }
//            static func description(type: SuccessfulType) -> String {
//                return "successful_transfer_\(type.rawValue)_desc".localized
//            }
//        }
//        struct SavingsPlan {
//            static func title(type: SuccessfulType) -> String {
//                return "successful_savingsplan_\(type.rawValue)_title".localized
//            }
//            static func description(type: SuccessfulType) -> String {
//                return "successful_savingsplan_\(type.rawValue)_desc".localized
//            }
//        }
//        struct Contribution {
//            static func title(type: SuccessfulType) -> String {
//                return "successful_contribution_\(type.rawValue)_title".localized
//            }
//            static func description(type: SuccessfulType) -> String {
//                return "successful_contribution_\(type.rawValue)_desc".localized
//            }
//        }
//        struct Subscription {
//            static func title(type: SuccessfulType) -> String {
//                return "successful_subscription_\(type.rawValue)_title".localized
//            }
//            static func description(type: SuccessfulType) -> String {
//                return "successful_subscription_\(type.rawValue)_desc".localized
//            }
//        }
//    }
//    
//    struct Delete {
//        struct Transaction {
//            static let title: String = "delete_transaction_title".localized
//            static let expenseMessage: String = "delete_transaction_expense_message".localized
//            static let incomeMessage: String = "delete_transaction_income_message".localized
//        }
//        struct Subscription {
//            static let title: String = "delete_subscription_title".localized
//            static let message: String = "delete_subscription_message".localized
//        }
//        struct Contribution {
//            static let title: String = "delete_contribution_title".localized
//            static let message: String = "delete_contribution_message".localized
//        }
//    }
//    
//    struct Setting {
//        struct General {
//            static let hapticFeedback: String = "setting_general_haptic_feedback".localized
//        }
//        struct Security {
//            static let description: String = "setting_security_description".localized
//            static let securityPlus: String = "setting_security_plus".localized
//            static let securityPlusDescription: String = "setting_security_plus_description".localized
//        }
//        struct Display {
//            static let homeScreen: String = "setting_display_displayed_home_screen".localized
//            static let nbrSubscriptions: String = "setting_display_nbr_subscriptions".localized
//            static let nbrSavingsPlans: String = "setting_display_nbr_savingsplans".localized
//            static let nbrTransactions: String = "setting_display_nbr_transactions".localized
//        }
//        struct Appearance {
//            static let appIcons: String = "setting_appearence_app_icons".localized
//            static let tintColor: String = "setting_appearence_tint_color".localized
//        }
//        struct Credits {
//            static let founders: String = "setting_credits_founders".localized
//            static let designers: String = "setting_credits_designers".localized
//            static let licences: String = "setting_credits_licences".localized
//        }
//        struct ApplePay {
//            static let addCategory: String = "setting_applepay_addcategory".localized
//            static let footer: String = "setting_applepay_footer".localized
//        }
//    }
//    
//    struct Paywall {
//        static let lifetime: String = "paywall_lifetime".localized
//        struct SavingsAccount {
//            static let desc: String = "paywall_savingsaccounts_desc".localized
//        }
//        struct CreditCard {
//            static let desc: String = "paywall_creditcards_desc".localized
//        }
//    }
//    
//    struct CreditCard {
//        static let expire: String = "creditcard_expire".localized
//        static let numbers: String = "creditcard_numbers".localized
//        static let holder: String = "creditcard_holder".localized
//        static let date: String = "creditcard_date".localized
//        static let cvv: String = "creditcard_cvv".localized
//        static let limit: String = "creditcard_limit".localized
//        static let security: String = "creditcard_security".localized
//        static let maxCard: String = "creditcard_maxCard".localized
//        static let maxCardMessage: String = "creditcard_maxCard_message".localized
//        static let deleteTitle: String = "creditcard_delete_title".localized
//    }
//    
//    struct SavingsAccount {
//        static let totalSavings: String = "savings_account_total_savings".localized
//    }
//    
//    struct WhatsNew {
//        static let title: String = "whatsnew_title".localized
//        static let userInterfaceTitle: String = "whatsnew_ui_title".localized
//        static let userInterface: String = "whatsnew_ui".localized
//        
//        static let stats: String = "whatsnew_stats".localized
//        static let creditcard: String = "whatsnew_creditcard".localized
//        static let applePayTitle: String = "whatsnew_applepay_title".localized
//        static let applePay: String = "whatsnew_applepay".localized
//        static let subscription: String = "whatsnew_subscription".localized
//    }
//    
//    struct Tips {
//        static let howToDo: String = "tip_how_to_do".localized
//        static let alreadyHaveShortcut: String = "tip_already_have_shortcut".localized
//        struct ApplePay {
//            static let descOne: String = "tip_applepay_desc_one".localized
//            static let descTwo: String = "tip_applepay_desc_two".localized
//        }
//    }
//    
//    struct Notifications {
//        static let daysBefore: String = "notifications_day_before".localized
//        static let footer: String = "notifications_footer".localized
//        static let willRemoved: String = "notifications_will_removed".localized
//        static let willAdded: String = "notifications_will_added".localized
//    }
//    
//    struct Statistics {
//        static let total: String = "statistics_total".localized
//        static let totalExpenses: String = "statistics_total_expenses".localized
//        static let totalIncomes: String = "statistics_total_incomes".localized
//        static let totalExpensesByMonth: String = "statistics_total_expenses_by_month".localized
//        static let totalIncomesByMonth: String = "statistics_total_incomes_by_month".localized
//        static let totalExpensesByWeek: String = "statistics_total_expenses_by_week".localized
//        static let totalIncomesByWeek: String = "statistics_total_incomes_by_week".localized
//        static let withSavings: String = "statistics_with_savings".localized
//    }
//    
//}
