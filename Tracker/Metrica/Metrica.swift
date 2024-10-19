//
//  Metrics.swift
//  Tracker
//
//  Created by Fedor on 30.09.2024.
//

import Foundation
import YandexMobileMetrica

final class Metrica {
    
    func report (event: Event, screen: Screen, item: Item? ) {
        var params: [AnyHashable : Any] = [ : ]
        var message = ""
        if let item = item {
            params = ["event": event.rawValue, "screen": screen.rawValue, "item": item.rawValue]
            message = "\(event.rawValue)_\(screen.rawValue)_\(item.rawValue)".lowercased()
        } else {
            params = ["event": event.rawValue, "screen": screen.rawValue]
            message = "\(event.rawValue)_\(screen.rawValue)".lowercased()
        }
        YMMYandexMetrica.reportEvent(message, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
