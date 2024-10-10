//
//  Date+Remove Time Day Extension.swift
//  Tracker
//
//  Created by Fedor on 31.07.2024.
//

import Foundation

extension Date {
    
    public var removeTimeInfo: Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else { return nil}
        return date
    }
    
    static func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
}

extension DateFormatter {
    
    static let dateFormatter = DateFormatter()
    
    static func removeTime(date: Date) -> Date {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        guard let updatedDate = dateFormatter.date(from: dateString) else { return Date() }
        return updatedDate
    }
}



