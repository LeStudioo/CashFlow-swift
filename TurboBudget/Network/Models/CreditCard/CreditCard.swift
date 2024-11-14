//
//  CreditCard.swift
//  FixBounce
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation

// Stocker en local dans le Keychain
// Redemander un mot de passe ou faceid pour voir
struct CreditCard {
    var id: UUID
    var holder: String
    var number: String
    var cvc: String
    var expirateDate: String
}
