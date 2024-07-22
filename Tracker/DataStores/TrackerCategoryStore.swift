//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Fedor on 22.07.2024.
//

import Foundation
import CoreData

final class TrackerCategoryStore {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        self.init(context: (DataStore().persistentContainer.viewContext))
    }
    
    func saveTrackerCategory(trackerCategory: TrackerCategory, tracker: Tracker) {
        let trackerRecordData = TrackerCategoryCoreData(context: context)
        let trackerData = TrackerCoreData(context: context)
        trackerData.trackerId = tracker.trackerId
        trackerData.name = tracker.name
        trackerData.emoji = tracker.emoji
        trackerData.color = tracker.color
        trackerData.schedule = tracker.schedule.joined(separator: ",")
        trackerRecordData.categoryName = trackerCategory.categoryName
        trackerRecordData.addToTrackersOfCategory(trackerData)
        saveTrackerCategory()
    }
    
    private func saveTrackerCategory(){
        do{
            try context.save()
        } catch {
            print("Ошибка сохранения")
        }
    }
}
