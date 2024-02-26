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

//PersistenceController
let persistenceController: PersistenceController = PersistenceController.shared

//
let currencySymbol = Locale(identifier: Locale.current.identifier).currencySymbol ?? "x"

//let hapticFeedback = UINotificationFeedbackGenerator()

//Color available
let colorsAvailable: [(Color, String)] = [
    (Color.red , "red"),
    (Color.orange , "orange"),
    (Color.yellow , "yellow"),
    (Color.green , "green"),
    (Color.mint , "mint"),
    (Color.teal , "teal"),
    (Color.cyan , "cyan"),
    (Color.blue , "blue"),
    (Color.indigo , "indigo"),
    (Color.purple , "purple"),
    (Color.pink , "pink"),
    (Color.brown , "brown")
]

//Theme Selected
var themeSelected: String {
    @Preference(\.colorSelected) var colorSelected
    
    if colorSelected == "111" {
        return "Green"
    } else if colorSelected == "222" {
        return "Blue"
    } else if colorSelected == "333" {
        return "Purple"
    } else if colorSelected == "444" {
        return "Red"
    } else { return "Green" }
}

//MARK: - Enum
enum ExpenseOrIncome: Int, CaseIterable {
    case expense, income
}
