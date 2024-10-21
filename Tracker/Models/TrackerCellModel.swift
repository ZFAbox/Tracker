//
//  TrackerCellModel.swift
//  Tracker
//
//  Created by Федор Завьялов on 21.08.2024.
//

import Foundation

struct TrackerCellModel {
    let tracker: Tracker
    let isCompletedToday: Bool
    let indexPath: IndexPath
    let completedDays: Int
    let currentDate: Date?
    let isCompletedBefore: Bool
    let isPined: Bool
    let metrica: Metrica
}
