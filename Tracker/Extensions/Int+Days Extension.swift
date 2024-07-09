//
//  Int+Days Extension.swift
//  Tracker
//
//  Created by Fedor on 18.06.2024.
//

import Foundation


extension Int {
    func daysEnding() -> String {
        var dayString: String!
        let remain = self % 10
        switch remain {
        case 1: dayString = "день"
        case 2, 3, 4: dayString = "дня"
        case 5, 6, 7, 8, 9, 0: dayString = "дней"
        default:
            dayString = "дней"
        }
        if 11...14 ~= self % 100 {dayString = "дней"}
        return "\(self) " + dayString
        }
}
