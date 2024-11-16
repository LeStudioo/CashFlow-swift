//
//  ContributionResponseWithAmount.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/11/2024.
//

import Foundation

struct ContributionResponseWithAmount: Codable {
    var newAmount: Double?
    var contribution: ContributionModel?
}
