//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Fedor on 22.07.2024.
//

import Foundation
import CoreData


final class TrackerRecordStore{
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        self.init(context: (DataStore().persistentContainer.viewContext))
    }
    
    func saveTrackerRecord(trackerRecord: TrackerRecord) {
        let trackerRecordData = TrackerRecordCoreData(context: context)
        trackerRecordData.trackerId = trackerRecord.trackerId
        trackerRecordData.trackerDate = trackerRecord.trackerDate
        saveTrackerRecord()
    }
    
    private func saveTrackerRecord(){
        do{
            try context.save()
        } catch {
            print("Ошибка сохранения")
        }
    }
}
