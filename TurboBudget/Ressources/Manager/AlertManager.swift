//
//  AlertManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/08/2024.
//

import Foundation

final class AlertManager: ObservableObject {
    
    @Published var isCardLimitSoonToBeExceeded: Bool = false
    @Published var isCardLimitExceeded: Bool = false
    @Published var isBudgetSoonToBeExceeded: Bool = false
    @Published var isBudgetExceed: Bool = false
    
}
