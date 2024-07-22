//
//  TrackerStore.swift
//  Tracker
//
//  Created by Fedor on 22.07.2024.
//

import Foundation
import CoreData

final class TrackerStore{
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        self.init(context: (DataStore().persistentContainer.viewContext))
    }
    
    func saveTracker(_ tracker: Tracker) {
        let trackerData = TrackerCoreData(context: context)
        trackerData.trackerId = tracker.trackerId
        trackerData.name = tracker.name
        trackerData.emoji = tracker.emoji
        trackerData.color = tracker.color
        trackerData.schedule = tracker.schedule.joined(separator: ",")
        saveTracker()
    }
    
    private func saveTracker(){
        do{
            try context.save()
        } catch {
            print("Ошибка сохранения")
        }
    }
}
