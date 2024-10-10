//
//  Metrics.swift
//  Tracker
//
//  Created by Fedor on 30.09.2024.
//

import Foundation
import YandexMobileMetrica

final class Metrica {
    
    func screenOpen(){
        let params : [AnyHashable : Any] = ["event": "open", "screen": "Main"]
        YMMYandexMetrica.reportEvent("open_main", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func screenClosed(){
        let params : [AnyHashable : Any] = ["event": "close", "screen": "Main"]
        YMMYandexMetrica.reportEvent("close_main", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func addTracker(){
        let params : [AnyHashable : Any] = ["event": "click", "screen": "Main", "item": "add_track"]
        YMMYandexMetrica.reportEvent("addTracker", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func completeTracker(){
        let params : [AnyHashable : Any] = ["event": "click", "screen": "Main", "item": "track"]
        YMMYandexMetrica.reportEvent("completeTracker", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func filterTracker(){
        let params : [AnyHashable : Any] = ["event": "click", "screen": "Main", "item": "filter"]
        YMMYandexMetrica.reportEvent("filterTrackers", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func editTracker(){
        let params : [AnyHashable : Any] = ["event": "click", "screen": "Main", "item": "edit"]
        YMMYandexMetrica.reportEvent("editTracker", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    
    func deleteTracker(){
        let params : [AnyHashable : Any] = ["event": "click", "screen": "Main", "item": "delete"]
        YMMYandexMetrica.reportEvent("deleteTracker", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
