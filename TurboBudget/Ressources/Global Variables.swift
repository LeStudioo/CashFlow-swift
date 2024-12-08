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

// TODO: Faire Currency.symbol
let currencySymbol = Locale(identifier: Locale.current.identifier).currencySymbol ?? "x"
let currencyName = Locale.autoupdatingCurrent.localizedString(forCurrencyCode: Locale.current.currency?.identifier ?? "x") ?? "x"
