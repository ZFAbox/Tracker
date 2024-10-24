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
        self.init(context: (DataStore.shared.viewContext))
    }
    
    func saveTrackerRecord(trackerRecord: TrackerRecord) {
        let trackerRecordData = TrackerRecordCoreData(context: context)
        trackerRecordData.trackerId = trackerRecord.trackerId
        trackerRecordData.trackerDate = trackerRecord.trackerDate
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerId), trackerRecord.trackerId as NSUUID)
        guard let tracker = try? context.fetch(request).first else { return }
        trackerRecordData.tracker = tracker
        saveTrackerRecord()
    }
    
    func deleteTrackerRecord(id: UUID, selectedDate: Date) {
        let request1 = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request1.predicate = NSPredicate(format: "%K == %@ AND %K == %@", #keyPath(TrackerCoreData.trackerRecord.trackerId),  id as NSUUID, )
        guard let tracker = try? context.fetch(request1).first else { return }
        tracker.trackerRecord.re
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@ AND %K == %@", #keyPath(TrackerRecordCoreData.trackerId), id as NSUUID, #keyPath(TrackerRecordCoreData.trackerDate), selectedDate as NSDate)
        guard let recordsData = try? context.fetch(request).first else { return }
 
        print (recordsData)
        context.delete(recordsData)
        saveTrackerRecord()
    }
    
    func isCompletedTrackerRecords(id: UUID, selectedDate: Date) -> Bool{
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@ AND %K == %@", #keyPath(TrackerRecordCoreData.trackerId), id as NSUUID, #keyPath(TrackerRecordCoreData.trackerDate), DateFormatter.removeTime(date: selectedDate) as NSDate)
        guard let recordsData = try? context.fetch(request).first else { return false }
            return true
    }
    
    func isCompletedTrackerBefore(id: UUID, date: Date) -> Bool{
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@ AND %K < %@", #keyPath(TrackerRecordCoreData.trackerId), id as NSUUID, #keyPath(TrackerRecordCoreData.trackerDate), date as NSDate)
        guard let recordsData = try? context.fetch(request) else { return false }
            let trackerRecordFound = recordsData.isEmpty ? false : true
            return trackerRecordFound
    }
    
    func completedTrackersCount(id:UUID) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.resultType = .countResultType
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerId), id as NSUUID)
        if let count = try? context.execute(request) as? NSAsynchronousFetchResult<NSFetchRequestResult> {
            return count.finalResult?.first as! Int
        } else { return 0 }
    }
    
    func calculateTrackersCompleted() -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        guard let trackerCompletedData = try? context.fetch(request) else { return 0}
        return trackerCompletedData.count
    }
    
    func calculateAverage() -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        guard let trackerCompletedData = try? context.fetch(request) else { return 0}
        let completedTrackersCount = trackerCompletedData.count
        let dateCount = Set( trackerCompletedData.map { trackerRecord in
            return trackerRecord.trackerDate
        }).count
        if dateCount == 0 { return 0 } else {
            let averageTrackersCountPerDay = Int (completedTrackersCount / dateCount)
            return averageTrackersCountPerDay
        }
    }
    
    func getCompletedDatesArray() -> [Date] {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        guard let trackerCompletedData = try? context.fetch(request) else { return [] }
        var dates = trackerCompletedData.map { trackerRecord in
            guard let date = trackerRecord.trackerDate else { preconditionFailure() }
            return date
        }
        let datesSet = Set(dates)
        dates = Array(datesSet).sorted(by: { d1, d2 in
            d1 < d2
        })
        return dates
    }
    
    func getCompletedTrackersPerDay(date: Date) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let predicate = NSPredicate(format: " %K == %@", #keyPath(TrackerRecordCoreData.trackerDate), date as NSDate)
        request.predicate = predicate
        guard let trackerCompletedData = try? context.fetch(request) else { return 0 }
        return trackerCompletedData.count
    }

    private func saveTrackerRecord(){
        do{
            try context.save()
        } catch {
            print("Ошибка сохранения")
        }
    }
}
