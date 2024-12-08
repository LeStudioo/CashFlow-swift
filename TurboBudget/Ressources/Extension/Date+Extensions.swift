//
//  Date+Extensions.swift
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
    
    func toISO() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
    
}

extension Date {
    
    var day: Int {
        var components = Calendar.current.dateComponents([.day, .month, .year], from: .now)
        components.timeZone = Locale.current.timeZone
        if let day = components.day { return day } else { return 0 }
    }
    
    var year: Int {
        var components = Calendar.current.dateComponents([.day, .month, .year], from: .now)
        components.timeZone = Locale.current.timeZone
        if let year = components.year { return year } else { return 0 }
    }
    
}

extension Date {
    
    var withTemporality: String {
        let calendar = Calendar.current
        let now = Date()
        
        let startOfToday = calendar.startOfDay(for: now)
        let startOfDate = calendar.startOfDay(for: self)
        
        if let daysDifference = calendar.dateComponents([.day], from: startOfToday, to: startOfDate).day {
            switch daysDifference {
            case 0:     return Word.Temporality.today
            case 1:     return Word.Temporality.tomorrow
            case -1:    return Word.Temporality.yesterday
            case 2:     return Word.Temporality.inTwoDays
            case -2:    return Word.Temporality.twoDaysAgo
            default:    break
            }
        }
        
        return self.formatted(date: .numeric, time: .omitted)
    }
    
}

extension Date {
    var startOfMonth: Date {
        let comp: DateComponents = Calendar.current.dateComponents([.month, .year], from: self)
        return Calendar.current.date(from: comp)!
    }

    var endOfMonth: Date {
        let start = self.startOfMonth
        return Calendar.current.date(byAdding: DateComponents(month: 1), to: start)!
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
    
}
