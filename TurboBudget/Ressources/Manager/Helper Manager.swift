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
        return formatter.string(from: date).firstLetterCapitalized
    }
    
    //MARK: - Double
    func removeLastDigit(from number: Double) -> Double {
        guard number >= 10 else {
            return 0 // Return 0 if the number has only one digit
        }
        return number / 10
    }
    
    //MARK: - OTHER
    //Get App Theme
    func getAppTheme() -> ThemeColor {
        for theme in themes {
            if theme.idUnique == UserDefaultsManager().colorSelected { return theme }
        }
        return themes[0] //Theme de base
    }
} //END struct
