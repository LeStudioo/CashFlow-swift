//
//  Helper Manager.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import Foundation
import SwiftUI

struct HelperManager {
    
    //MARK: - DATE
    //-------------------- stringDateDay ----------------------
    // Description : Convert a date day to string
    // Parameter : date -> Date
    // Output : return String
    // Extra : No
    //-----------------------------------------------------------
    func stringDateDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Locale.current.identifier.contains("FR") ? "dd/MM/yyyy" : "MM/dd/yyyy" //TODO: Revoir en fonction des autres pays
        return formatter.string(from: date)
    }
    
    //-------------------- formattedDateWithDayMonthYear ----------------------
    // Description : Convertit une date en une chaîne de caractères au format "jour mois année"
    // Parameter : date: Date
    // Output : return String
    // Extra : Cette fonction utilise un DateFormatter pour formater la date en "dd MMMM yyyy"
    //-----------------------------------------------------------
    func formattedDateWithDayMonthYear(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    //-------------------- formattedDateWithMonthYear ----------------------
    // Description : Convertit une date en une chaîne de caractères au format "mois année"
    // Parameter : date: Date
    // Output : return String
    // Extra : Cette fonction utilise un DateFormatter pour formater la date en "MMMM yyyy"
    //-----------------------------------------------------------
    func formattedDateWithMonthYear(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date).capitalized
    }
    
} // End struct
