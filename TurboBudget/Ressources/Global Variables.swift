//
//  Global Variables.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//

import Foundation
import SwiftUI

//Device
let isIPad = (UIDevice.current.userInterfaceIdiom == .pad)
let isLittleIphone = UIScreen.main.bounds.width < 380 ? true : false

//
let currencySymbol = Locale(identifier: Locale.current.identifier).currencySymbol ?? "x"

//MARK: - Enum
enum ExpenseOrIncome: Int, CaseIterable {
    case expense = 0
    case income = 1
}
