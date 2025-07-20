////
////  Date+Extensions.swift
////  TurboBudget
////
////  Created by Théo Sementa on 16/06/2023.
////
//
//import Foundation
//
//extension Optional where Wrapped == Date {
//    
//    var withDefault: Date {
//        return self ?? .now
//    }
//    
//}
//
//extension Date {
//    
//    func toISO() -> String {
//        let formatter = ISO8601DateFormatter()
//        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        return formatter.string(from: self)
//    }
//    
//    func toQueryParam() -> String {
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone(identifier: "UTC")
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: self)
//    }
//    
//}
//
//extension Date {
//    
//    func hasPassed(days: Int) -> Bool {
//        guard let targetDate = Calendar.current.date(byAdding: .day, value: days, to: self) else {
//            return false
//        }
//        return Date() >= targetDate
//    }
//    
////    func monthsBetween(to date: Date) -> Int {
////        let calendar = Calendar.current
////        let components = calendar.dateComponents([.month], from: self, to: date)
////        return components.month ?? 0
////    }
////    
//    func daysSince() -> Int {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.day], from: self, to: Date())
//        return components.day ?? 0
//    }
//    
//    func daysTo() -> Int {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.day], from: Date(), to: self)
//        return components.day ?? 0
//    }
//    
//}
//
//extension Date {
//    
//    var day: Int {
//        var components = Calendar.current.dateComponents([.day, .month, .year], from: self)
//        components.timeZone = Locale.current.timeZone
//        if let day = components.day { return day } else { return 0 }
//    }
//    
//    var week: Int {
//        let calendar = Calendar.current
//        return calendar.component(.weekOfYear, from: self)
//    }
//    
//    var month: Int {
//        var components = Calendar.current.dateComponents([.day, .month, .year], from: self)
//        components.timeZone = Locale.current.timeZone
//        if let month = components.month { return month } else { return 0 }
//    }
//    
//    var year: Int {
//        var components = Calendar.current.dateComponents([.day, .month, .year], from: self)
//        components.timeZone = Locale.current.timeZone
//        if let year = components.year { return year } else { return 0 }
//    }
//    
//}
//
//extension Date {
//    
//    var withTemporality: String {
//        let calendar = Calendar.current
//        let now = Date()
//        
//        let startOfToday = calendar.startOfDay(for: now)
//        let startOfDate = calendar.startOfDay(for: self)
//        
//        if let daysDifference = calendar.dateComponents([.day], from: startOfToday, to: startOfDate).day {
//            switch daysDifference {
//            case 0:     return Word.Temporality.today
//            case 1:     return Word.Temporality.tomorrow
//            case -1:    return Word.Temporality.yesterday
//            case 2:     return Word.Temporality.inTwoDays
//            case -2:    return Word.Temporality.twoDaysAgo
//            default:    break
//            }
//        }
//        
//        return self.formatted(date: .numeric, time: .omitted)
//    }
//    
//}
//
//extension Date {
//    
//    var startOfMonth: Date {
//        var calendar = Calendar.current
//        calendar.timeZone = TimeZone.autoupdatingCurrent
//        let components = calendar.dateComponents([.year, .month], from: self)
//        return  calendar.date(from: components)!
//    }
//    
//    var endOfMonth: Date {
//        var calendar = Calendar.current
//        calendar.timeZone = TimeZone.autoupdatingCurrent
//        calendar.locale = Locale.current
//        let lastDayOfCurrentMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
//        return lastDayOfCurrentMonth
//    }
//    
//    var oneMonthAgo: Date {
//        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
//    }
//    
//    var inOneMonth: Date {
//        return Calendar.current.date(byAdding: .month, value: 1, to: self)!
//    }
//    
//    var inOneYear: Date {
//        return Calendar.current.date(byAdding: .year, value: 1, to: self)!
//    }
//    
//    var oneYearAgo: Date {
//        return Calendar.current.date(byAdding: .year, value: -1, to: self)!
//    }
//    
//    var startOfYear: Date {
//        let components = Calendar.current.dateComponents([.year], from: self)
//        return Calendar.current.date(from: components)!
//    }
//    
//    var allDateOfMonth: [Date] {
//        var dates = [Date]()
//        var start = self.startOfMonth
//        let end = self.endOfMonth
//
//        while start <= end {
//            dates.append(start)
//            guard let nextDate = Calendar.current.date(byAdding: DateComponents(day: 1), to: start) else { break }
//            start = nextDate
//        }
//
//        return dates
//    }
//    
//    var oneWeekLater: Date {
//        let calendar = Calendar.current
//        let date = calendar.date(byAdding: .weekOfYear, value: 1, to: self)!
//        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
//        return calendar.date(from: components)!
//    }
//    
//    var twoWeekLater: Date {
//        let calendar = Calendar.current
//        let date = calendar.date(byAdding: .weekOfYear, value: 2, to: self)!
//        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
//        return calendar.date(from: components)!
//    }
//    
//}
//
//extension Date {
//    
//    func formatCardExpiration() -> String {
//        let locale = Locale.current
//        let formatter = DateFormatter()
//        formatter.locale = locale
//        formatter.dateFormat = locale.identifier.hasPrefix("en") ? "yy/MM" : "MM/yy" 
//        return formatter.string(from: self)
//    }
//    
//}
