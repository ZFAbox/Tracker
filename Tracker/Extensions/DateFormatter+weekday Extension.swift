//
//  Date+weekday Extension.swift
//  Tracker
//
//  Created by Федор Завьялов on 09.07.2024.
//

import Foundation

extension DateFormatter {
    
    static func weekday(date: Date) -> String {
        let weekdayNumber = Calendar.current.dateComponents([.weekday], from: date).weekday
        var weekday = "Нет такого дня недели"
        if let weekdayNumber = weekdayNumber {
            switch weekdayNumber {
            case 1: weekday = Weekdays.Sunday.rawValue
            case 2: weekday = Weekdays.Monday.rawValue
            case 3: weekday = Weekdays.Tuesday.rawValue
            case 4: weekday = Weekdays.Wednesday.rawValue
            case 5: weekday = Weekdays.Thursday.rawValue
            case 6: weekday = Weekdays.Friday.rawValue
            case 7: weekday = Weekdays.Saturday.rawValue
            default: weekday = "Нет такого дня недели"
            }
        }
        return weekday
    }
    
    static let df = DateFormatter()
    
    func prepareDatePickerString(date: Date) -> String {
        let dateFormatter = DateFormatter.df
        dateFormatter.dateFormat = "dd.MM.yy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
