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
    
    
    func deleteTrackerTrcord(trackerRecord: TrackerRecord) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == $@", #keyPath(TrackerRecordCoreData.trackerId), trackerRecord.trackerId as NSUUID)
        if let objects = try? context.fetch(request) {
            for object in objects {
                context.delete(object)
            }
        }
    }
    
    private func saveTrackerRecord(){
        do{
            try context.save()
        } catch {
            print("Ошибка сохранения")
        }
    }
}
