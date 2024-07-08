//
//  Date+weekday Extension.swift
//  Tracker
//
//  Created by Федор Завьялов on 09.07.2024.
//

import Foundation

extension DateFormatter {
    
    static let dateFormatter = DateFormatter()
    
    static func weekday(date: Date) -> String {
        
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: date).capitalized
        switch weekday {
        case "Sunday":
            return Weekdays.Sunday.rawValue
        case "Monday":
            return Weekdays.Monday.rawValue
        case "Tuesday":
            return Weekdays.Tuesday.rawValue
        case "Wednesday":
            return Weekdays.Wednesday.rawValue
        case "Thursday":
            return Weekdays.Thursday.rawValue
        case "Friday":
            return Weekdays.Friday.rawValue
        case "Saturday":
            return Weekdays.Saturday.rawValue
        default:
            return ""
        }
    }
}
