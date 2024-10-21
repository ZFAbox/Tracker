//
//  Parameters.swift
//  Tracker
//
//  Created by Fedor on 14.10.2024.
//

import Foundation

enum Event: String{
    case open = "open"
    case close = "close"
    case click = "click"
}

enum Screen: String {
    case main = "Main"
}

enum Item: String {
    case addTracker = "add_track"
    case completeTracker = "track"
    case filterTracker = "filter"
    case editTracker = "edit"
    case deleteTracker = "delete"
}
