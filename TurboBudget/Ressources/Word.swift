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
    }
    
    struct Create {
        static let addCategory: String = "create_add_category".localized
    }
    
    struct Title {
        static let newTransaction: String = "title_new_transaction".localized
    }
    
}
