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
            case 1: weekday = "7"
            case 2: weekday = "1"
            case 3: weekday = "2"
            case 4: weekday = "3"
            case 5: weekday = "4"
            case 6: weekday = "5"
            case 7: weekday = "6"
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
