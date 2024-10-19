//
//  Weekdays.swift
//  Tracker
//
//  Created by Федор Завьялов on 12.10.2024.
//

import Foundation

enum Weekdays: String, Codable{
    
    case Sunday = "7"
    case Monday = "1"
    case Tuesday = "2"
    case Wednesday = "3"
    case Thursday = "4"
    case Friday = "5"
    case Saturday = "6"
    
    var localized: String {
        switch self {
        case .Sunday:
            return NSLocalizedString("Sunday", comment: "")
        case .Monday:
            return NSLocalizedString("Monday", comment: "")
        case.Tuesday:
            return NSLocalizedString("Tuesday", comment: "")
        case .Wednesday:
            return NSLocalizedString("Wednesday", comment: "")
        case . Thursday:
            return NSLocalizedString("Thursday", comment: "")
        case .Friday:
            return NSLocalizedString("Friday", comment: "")
        case .Saturday:
            return NSLocalizedString("Saturday", comment: "")
        }
    }
    
    static let notRegularTrackerSchedule: [ String ] = {
        var array:[String] = []
        for i in 0...6 {
            array.append(weekdayForIndex(at: i).rawValue)
        }
        return array
    }()
    
    static let scheduleSubtitlesArray: [ String ] = {
        var array:[String] = []
        for i in 1...7 {
            array.append(shortWeekdayDescription(weekdayNumber: i))
        }
        return array
    }()
    
    static func scheduleSubtitles(schedule: [String]) -> String {
        let subtitles = schedule.map { weekdayNumber in
            return  self.shortWeekdayDescription(weekdayNumber: Int(weekdayNumber) ?? 0)
        }
        return subtitles.joined(separator: ", ")
    }
    
    static func shortWeekdayDescription(weekdayNumber: Int) -> String {
        switch weekdayNumber {
        case 7:
            return NSLocalizedString("Sun", comment: "")
        case 1:
            return NSLocalizedString("Mon", comment: "")
        case 2:
            return NSLocalizedString("Tues", comment: "")
        case 3:
            return NSLocalizedString("Wed", comment: "")
        case 4:
            return NSLocalizedString("Thurs", comment: "")
        case 5:
            return NSLocalizedString("Fri", comment: "")
        case 6:
            return NSLocalizedString("Sat", comment: "")
        default: return "Ошибка: некоректный номер дня недели"
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
    
    static func weekdayDescriptionForWeekday(at weekday: String) -> Weekdays {
        switch weekday {
        case Weekdays.Monday.localized:
            return Weekdays.Monday
        case Weekdays.Tuesday.localized:
            return Weekdays.Tuesday
        case Weekdays.Wednesday.localized:
            return Weekdays.Wednesday
        case Weekdays.Thursday.localized:
            return Weekdays.Thursday
        case Weekdays.Friday.localized:
            return Weekdays.Friday
        case Weekdays.Saturday.localized:
            return Weekdays.Saturday
        case Weekdays.Sunday.localized:
            return Weekdays.Sunday
        default:
            preconditionFailure("Не корректное наименование дня недели")
        }
    }
}
