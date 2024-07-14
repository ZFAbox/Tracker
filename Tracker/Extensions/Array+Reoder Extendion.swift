//
//  Array+Reoder Extendion.swift
//  Tracker
//
//  Created by Федор Завьялов on 14.07.2024.
//

import Foundation


extension Array where Element: Equatable {

    func reorder(by preferredOrder: [Element]) -> [Element] {

        return self.sorted { (a, b) -> Bool in
            guard let first = preferredOrder.firstIndex(of: a) else {
                return false
            }

            guard let second = preferredOrder.firstIndex(of: b) else {
                return true
            }

            return first < second
        }
    }
}
