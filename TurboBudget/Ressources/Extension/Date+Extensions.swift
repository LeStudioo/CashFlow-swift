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
