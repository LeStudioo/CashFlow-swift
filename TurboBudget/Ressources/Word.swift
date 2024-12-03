//
//  Word.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import Foundation

struct Word {
    
    struct Classic {
        static let category: String = "word_category".localized
        static let name: String = "word_name".localized
        static let price: String = "word_price".localized
        static let typeOfTransaction: String = "word_typeOfTransaction".localized
        static let typeOfContribution: String = "word_typeOfContribution".localized
        static let date: String = "word_date".localized
        static let recommended: String = "word_recommended".localized
        static let expense: String = "word_expense".localized
        static let income: String = "word_income".localized
        static let transfer: String = "word_transfer".localized
        static let subscription: String = "word_subscription".localized
        static let dayOfAutomation: String = "word_dayOfAutomation".localized
        static let initialAmount: String = "word_initialAmount".localized
        static let amountToReach: String = "word_amountToReach".localized
        static let finalTargetDate: String = "word_finalTargetDate".localized
        static let startTargetDate: String = "word_startTargetDate".localized
        static let edit: String = "word_edit".localized
        static let create: String = "word_create".localized
        static let senderAccount: String = "word_senderAccount".localized
        static let receiverAccount: String = "word_receiverAccount".localized
        static let subscriptionFuturDate: String = "word_subscriptionFuturDate".localized
        static let frequency: String = "word_frequency".localized
        static let received: String = "word_received".localized
        static let sent: String = "word_sent".localized
        static let retry: String = "word_retry".localized
    }
    
    struct Preposition {
        static let to: String = "word_preposition_to".localized
        static let from: String = "word_preposition_from".localized
    }
    
    struct Create {
        static let addCategory: String = "create_add_category".localized
    }
    
    struct Sync {
        static let continueWithoutData: String = "sync_continue_without_data".localized
        static let sorryMessage: String = "sync_sorry_message".localized
        static let fetching: String = "sync_fetching".localized
    }
    
    struct Frequency {
        static let weekly: String = "frequency_weekly".localized
        static let monthly: String = "frequency_monthly".localized
        static let yearly: String = "frequency_yearly".localized
    }
    
    struct Title {
        struct Transaction {
            static let new: String = "title_new_transaction".localized
            static let update: String = "title_update_transaction".localized
            static let home: String = "title_home_transactions".localized
        }
        struct Transfer {
            static let new: String = "title_new_transfer".localized
        }
        struct Subscription {
            static let new: String = "title_new_subscription".localized
            static let update: String = "title_update_subscription".localized
            static let home: String = "title_home_subscriptions".localized
        }
        struct SavingsPlan {
            static let new: String = "title_new_savingsPlan".localized
            static let update: String = "title_update_savingsPlan".localized
            static let home: String = "title_home_savingsPlans".localized
        }
    }
    
    struct Empty {
        struct Transaction {
            static let desc: String = "empty_transactions_desc".localized
        }
        struct Subscription {
            static let desc: String = "empty_subscriptions_desc".localized
        }
        struct SavingsPlan{
            static let desc: String = "empty_savingsPlans_desc".localized
        }
    }
    
    struct Successful {
        struct Transaction {
            static func title(type: SuccessfulType) -> String {
                return "successful_transaction_\(type.rawValue)_title".localized
            }
            static func description(type: SuccessfulType) -> String {
                return "successful_transaction_\(type.rawValue)_desc".localized
            }
        }
        struct Transfer {
            static func title(type: SuccessfulType) -> String {
                return "successful_transfer_\(type.rawValue)_title".localized
            }
            static func description(type: SuccessfulType) -> String {
                return "successful_transfer_\(type.rawValue)_desc".localized
            }
        }
        struct SavingsPlan {
            static func title(type: SuccessfulType) -> String {
                return "successful_savingsplan_\(type.rawValue)_title".localized
            }
            static func description(type: SuccessfulType) -> String {
                return "successful_savingsplan_\(type.rawValue)_desc".localized
            }
        }
        struct Contribution {
            static func title(type: SuccessfulType) -> String {
                return "successful_contribution_\(type.rawValue)_title".localized
            }
            static func description(type: SuccessfulType) -> String {
                return "successful_contribution_\(type.rawValue)_desc".localized
            }
        }
        struct Subscription {
            static func title(type: SuccessfulType) -> String {
                return "successful_subscription_\(type.rawValue)_title".localized
            }
            static func description(type: SuccessfulType) -> String {
                return "successful_subscription_\(type.rawValue)_desc".localized
            }
        }
        
    }
    
}
