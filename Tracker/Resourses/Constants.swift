//
//  Constants.swift
//  Tracker
//
//  Created by Федор Завьялов on 09.07.2024.
//

import Foundation
import UIKit

enum Weekdays: String, Codable{
    case Sunday = "Воскресенье"
    case Monday = "Понедельник"
    case Tuesday = "Вторник"
    case Wednesday = "Среда"
    case Thursday = "Четверг"
    case Friday = "Пятница"
    case Saturday = "Суббота"
    
    static let notRegularTrackerSchedule: [ String ] = {
        var array:[String] = []
        for i in 0...6 {
            array.append(weekdayForIndex(at: i).rawValue)
        }
        return array
    }()
    
    static let scheduleSubtitlesArray: [ String ] = {
        var array:[String] = []
        for i in 0...6 {
            array.append(shortWeekdayDescription(weekday: weekdayForIndex(at: i)))
        }
        return array
    }()
    
//
//    ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    static func shortWeekdayDescription(weekday: Weekdays) -> String {
        switch weekday {
        case .Sunday:
            return "Вс"
        case .Monday:
            return "Пн"
        case .Tuesday:
            return "Вт"
        case .Wednesday:
            return "Ср"
        case .Thursday:
            return "Чт"
        case .Friday:
            return "Пт"
        case .Saturday:
            return "Сб"
        }
    }
    
    static func weekdayForIndex(at index: Int) -> Weekdays {
        switch index {
        case 0:
            return Weekdays.Monday
        case 1:
            return Weekdays.Tuesday
        case 2:
            return Weekdays.Wednesday
        case 3:
            return Weekdays.Thursday
        case 4:
            return Weekdays.Friday
        case 5:
            return Weekdays.Saturday
        case 6:
            return Weekdays.Sunday
        default:
            preconditionFailure("Не корректный индекс метки switch.tag")
        }
    }
    
}


struct Constants {
    
    static let colors: [UIColor] = [
        UIColor.rgbColors(red: 253, green: 76, blue: 73, alpha: 1),
        UIColor.rgbColors(red: 255, green: 136, blue: 30, alpha: 1),
        UIColor.rgbColors(red: 0, green: 123, blue: 250, alpha: 1),
        UIColor.rgbColors(red: 110, green: 68, blue: 254, alpha: 1),
        UIColor.rgbColors(red: 51, green: 207, blue: 105, alpha: 1),
        UIColor.rgbColors(red: 230, green: 109, blue: 212, alpha: 1),
        UIColor.rgbColors(red: 249, green: 212, blue: 212, alpha: 1),
        UIColor.rgbColors(red: 52, green: 167, blue: 254, alpha: 1),
        UIColor.rgbColors(red: 70, green: 230, blue: 157, alpha: 1),
        UIColor.rgbColors(red: 53, green: 52, blue: 124, alpha: 1),
        UIColor.rgbColors(red: 255, green: 103, blue: 77, alpha: 1),
        UIColor.rgbColors(red: 255, green: 153, blue: 204, alpha: 1),
        UIColor.rgbColors(red: 236, green: 196, blue: 139, alpha: 1),
        UIColor.rgbColors(red: 121, green: 148, blue: 245, alpha: 1),
        UIColor.rgbColors(red: 131, green: 44, blue: 241, alpha: 1),
        UIColor.rgbColors(red: 173, green: 86, blue: 218, alpha: 1),
        UIColor.rgbColors(red: 141, green: 214, blue: 230, alpha: 1),
        UIColor.rgbColors(red: 47, green: 208, blue: 88, alpha: 1)
    ]
    
    static let selectionColors: [UIColor] = [
        UIColor.rgbColors(red: 253, green: 76, blue: 73, alpha: 0.3),
        UIColor.rgbColors(red: 255, green: 136, blue: 30, alpha: 0.3),
        UIColor.rgbColors(red: 0, green: 123, blue: 250, alpha: 0.3),
        UIColor.rgbColors(red: 110, green: 68, blue: 254, alpha: 0.3),
        UIColor.rgbColors(red: 51, green: 207, blue: 105, alpha: 0.3),
        UIColor.rgbColors(red: 230, green: 109, blue: 212, alpha: 0.3),
        UIColor.rgbColors(red: 249, green: 212, blue: 212, alpha: 0.3),
        UIColor.rgbColors(red: 52, green: 167, blue: 254, alpha: 0.3),
        UIColor.rgbColors(red: 70, green: 230, blue: 157, alpha: 0.3),
        UIColor.rgbColors(red: 53, green: 52, blue: 124, alpha: 0.3),
        UIColor.rgbColors(red: 255, green: 103, blue: 77, alpha: 0.3),
        UIColor.rgbColors(red: 255, green: 153, blue: 204, alpha: 0.3),
        UIColor.rgbColors(red: 236, green: 196, blue: 139, alpha: 0.3),
        UIColor.rgbColors(red: 121, green: 148, blue: 245, alpha: 0.3),
        UIColor.rgbColors(red: 131, green: 44, blue: 241, alpha: 0.3),
        UIColor.rgbColors(red: 173, green: 86, blue: 218, alpha: 0.3),
        UIColor.rgbColors(red: 141, green: 214, blue: 230, alpha: 0.3),
        UIColor.rgbColors(red: 47, green: 208, blue: 88, alpha: 0.3)
    ]
    
    static let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
}

