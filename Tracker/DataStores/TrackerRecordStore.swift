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
        if let tracker = try? context.fetch(request).first {
            trackerRecordData.tracker = tracker
        }
        saveTrackerRecord()
    }
    
    func deleteTrackerRecord(id: UUID, currentDate: Date) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerId), id as NSUUID)
        if let recordsData = try? context.fetch(request) {
            recordsData.forEach { record in
                if let trackerRecordDate = record.trackerDate {
                    let isTheSameDay = Calendar.current.isDate(trackerRecordDate, inSameDayAs: currentDate)
                    if isTheSameDay {
                        context.delete(record)
                    }
                }
            }
        }
        saveTrackerRecord()
    }
    
    func loadTrackerRecords() -> [TrackerRecord]{
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        guard let trackerRecordsData = try? context.fetch(request) else { return [] }
        var trackerRecords: [TrackerRecord] = []
        trackerRecordsData.forEach { trackerRecordData in
            let trackerRecord = TrackerRecord(trackerId: trackerRecordData.trackerId ?? UUID(), trackerDate: trackerRecordData.trackerDate ?? Date())
            trackerRecords.append(trackerRecord)
        }
        return trackerRecords
    }
    
    func isCompletedTrackerRecords(id: UUID, date: Date) -> Bool{
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@ AND %K == %@", #keyPath(TrackerRecordCoreData.trackerId), id as NSUUID, #keyPath(TrackerRecordCoreData.trackerDate), date as NSDate)
        guard let recordsData = try? context.fetch(request) else { return false }
            let trackerRecordFound = recordsData.isEmpty ? false : true
            return trackerRecordFound
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
    
    func isEverCompleted(id: UUID, currentDate: Date) -> Bool{
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        var trackerRecordFound = false
        request.predicate = NSPredicate(format: "%K == %@ AND %K < %@", #keyPath(TrackerRecordCoreData.trackerId), id as NSUUID, #keyPath(TrackerRecordCoreData.trackerDate), currentDate as NSDate)
        if (try? context.fetch(request).isEmpty) != nil {
            trackerRecordFound = false
        } else {
            trackerRecordFound = true
        }
        return trackerRecordFound
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
