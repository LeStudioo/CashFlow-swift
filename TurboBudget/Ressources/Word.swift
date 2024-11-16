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
        static let date: String = "word_date".localized
        static let recommended: String = "word_recommended".localized
        static let expense: String = "word_expense".localized
        static let income: String = "word_income".localized
        static let dayOfAutomation: String = "word_dayOfAutomation".localized
        static let initialAmount: String = "word_initialAmount".localized
        static let amountToReach: String = "word_amountToReach".localized
        static let finalTargetDate: String = "word_finalTargetDate".localized
        static let startTargetDate: String = "word_startTargetDate".localized
    }
    
    struct Create {
        static let addCategory: String = "create_add_category".localized
    }
    
    struct Title {
        static let newTransaction: String = "title_new_transaction".localized
        static let newAutomation: String = "title_new_automation".localized
        static let newSavingsPlan: String = "title_new_savingsPlan".localized
    }
    
}
