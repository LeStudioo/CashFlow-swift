//
//  ShoppingCategory.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

enum ShoppingCategory: String, CaseIterable {
    case sportingGoods
    case gifts
    case donations
    case techAndGames
    case booksAndMusic
    case furnitureAndDecoration
    case personalLoans
    case tobaccoAndPress
    case clothesShoes
    case other
    
    static let title: String = "category1_name".localized
}
