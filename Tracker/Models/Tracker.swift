//
//  Tracker.swift
//  Tracker
//
//  Created by Fedor on 07.06.2024.
//

import Foundation
import UIKit

struct Tracker {
    let trackerId: UUID
    let name: String
    let emoji: String
    let color: UIColor
    let schedule: [String]
    let isRegular: Bool
    let createDate: Date
}
