//
//  Date Extention.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//

import Foundation

extension Optional where Wrapped == Date {
    
    var withDefault: Date {
        return self ?? .now
    }
    
}

extension Date {
    
    var day: Int {
        var components = Calendar.current.dateComponents([.day, .month, .year], from: .now)
        components.timeZone = Locale.current.timeZone
        if let day = components.day { return day } else { return 0 }
    }
    
}

extension Date {
    var startOfMonth: Date {
        let comp: DateComponents = Calendar.current.dateComponents([.month, .year], from: self)
        return Calendar.current.date(from: comp)!
    }
    
    var numStartOfMonth: Int {
        let comp: DateComponents = Calendar.current.dateComponents([.day], from: startOfMonth)
        return comp.day ?? 0
    }
    
    var endOfMonth: Date {
        let start = self.startOfMonth
        return Calendar.current.date(byAdding: DateComponents(month: 1), to: start)!
    }
    
    var numEndOfMonth: Int {
        let start = self.startOfMonth
        let end = Calendar.current.date(byAdding: DateComponents(month: 1), to: start)!
        let date = Calendar.current.date(byAdding: .day, value: -1, to: end)!
        let comp = Calendar.current.dateComponents([.day], from: date)
        return comp.day ?? 0
    }
    
    var allDateOfMonth: [Date] {
        var dates = [Date]()
        var start = self.startOfMonth
        let end = self.endOfMonth

        while start <= end {
            dates.append(start)
            guard let nextDate = Calendar.current.date(byAdding: DateComponents(day: 1), to: start) else { break }
            start = nextDate
        }

        return dates
    }
    
    //-------------------- currentDayOfMonth ----------------------
    // Description : Récupère le numéro du jour actuel du mois
    // Output : return Int
    // Extra : Cette fonction utilise le calendrier actuel pour obtenir le numéro du jour. Si la date ne peut pas être récupérée, elle renvoie 0.
    //-----------------------------------------------------------
    func currentDayOfMonth() -> Int {
        var components = Calendar.current.dateComponents([.day, .month, .year], from: .now)
        components.timeZone = Locale.current.timeZone
        if let day = components.day { return day } else { return 0 }
    }
    
    //-------------------- currentYearValue ----------------------
    // Description : Récupère la valeur de l'année actuelle
    // Output : return Int
    // Extra : Cette fonction utilise le calendrier actuel pour obtenir la valeur de l'année. Si la date ne peut pas être récupérée, elle renvoie 0.
    //-----------------------------------------------------------
    func currentYearValue() -> Int {
        var components = Calendar.current.dateComponents([.year], from: .now)
        components.timeZone = Locale.current.timeZone
        if let year = components.year { return year } else { return 0 }
    }
}
