//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Fedor on 22.07.2024.
//

import Foundation
import CoreData
import UIKit

protocol TrackerStoreUpdateDelegateProtocol {
    func updateTrackers(with indexPathAndSection: IndexPathAndSection)
}

struct IndexPathAndSection {
    let indexPath: IndexPath
    let section: Int?
}

final class TrackerCategoryStore: NSObject {
    
    private var context: NSManagedObjectContext
    private var delegate: TrackerStoreUpdateDelegateProtocol?
    private var currentDate: Date?
    private var searchedText: String
    private var insertedIndexes: IndexPath?
    private var oldNumberOfSection: Int = 0
    private var insertedSections: Int?
    
    init(context: NSManagedObjectContext, delegate: TrackerStoreUpdateDelegateProtocol, currentDate: Date?, searchedText: String) {
        self.context = context
        self.delegate = delegate
        self.currentDate = currentDate
        self.searchedText = searchedText
    }
    
    convenience init(delegate: TrackerStoreUpdateDelegateProtocol, currentDate: Date?, searchedText: String) {
        self.init(context: DataStore.shared.viewContext, delegate: delegate, currentDate: currentDate, searchedText: searchedText)
    }
    
    private lazy var fetchedResultController: NSFetchedResultsController<TrackerCoreData> = {
        let currentDate = self.currentDate ?? Date()
        let weekday = DateFormatter.weekday(date: currentDate)
        let searchedText = (self.searchedText).lowercased()
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        if searchedText == "" {
            fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday)
        } else {
            fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[n] %@ AND %K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday, #keyPath(TrackerCoreData.name.lowercased), searchedText)
        }
        let sortDescriptor = NSSortDescriptor(key: #keyPath(TrackerCoreData.name), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.categoryName),
            cacheName: nil)
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        return fetchedResultController
    }()
    
    func saveTrackerCategory(categoryName: String, tracker: Tracker) {
        let trackerData = TrackerCoreData(context: context)
        trackerData.trackerId = tracker.trackerId
        trackerData.name = tracker.name
        trackerData.emoji = tracker.emoji
        trackerData.color = UIColor.getHexColor(from: tracker.color)
        trackerData.schedule = tracker.schedule.joined(separator: ",")
        trackerData.isRegular = tracker.isRegular
        trackerData.createDate = tracker.createDate
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == '\(categoryName)'", #keyPath(TrackerCategoryCoreData.categoryName))
        if let category = try? context.fetch(request).first {
            trackerData.category = category
        } else {
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.categoryName = categoryName
            trackerCategoryCoreData.addToTrackersOfCategory(trackerData)
        }
        saveContext()
    }
    
//    func updateDateAndText(weekday: String, searchedText: String ) {
//        if searchedText == "" {
//            fetchedResultController.fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday)
//            try? fetchedResultController.performFetch()
//        } else {
//            fetchedResultController.fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[n] %@ AND %K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday, #keyPath(TrackerCoreData.name.lowercased), searchedText)
//            try? fetchedResultController.performFetch()
//        }
//    }
    
    func updateDateAndText(currentDate: Date, searchedText: String ) {
        let weekday = DateFormatter.weekday(date: currentDate)
        if searchedText == "" {
            let  textAndDatePredicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday)
            
            let notRegular = NSPredicate(format: "%K == false", #keyPath(TrackerCoreData.isRegular))
            let isCompleted = NSPredicate(format: "Any %K >= %@",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let isCompletedDateEmpty = NSPredicate(format: "Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let notVisibleBeforeCreate = NSPredicate(format: "%K <= %@",  #keyPath(TrackerCoreData.createDate), currentDate as NSDate)
            let notRegularAndCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, isCompleted])
            let NotCompletedAndCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [isCompletedDateEmpty, notRegularAndCompleted])
            
            let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [NotCompletedAndCompleted, textAndDatePredicate, notVisibleBeforeCreate])
            
            fetchedResultController.fetchRequest.predicate = predicate
            try? fetchedResultController.performFetch()
            
        } else {
            fetchedResultController.fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[n] %@ AND %K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday, #keyPath(TrackerCoreData.name.lowercased), searchedText)
            try? fetchedResultController.performFetch()
        }
    }
    
    
    
    var numberOfSections: Int {
        fetchedResultController.sections?.count ?? 0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int{
        fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(_ indexPath: IndexPath) -> Tracker? {
        let trackerCoreData = fetchedResultController.object(at: indexPath)
        let tracker = Tracker(
            trackerId: trackerCoreData.trackerId ?? UUID(),
            name: trackerCoreData.name ?? "",
            emoji: trackerCoreData.emoji ?? "🤬",
            color: UIColor.getUIColor(from: trackerCoreData.color ?? "#FFFFFF"),
            schedule: trackerCoreData.schedule?.components(separatedBy: ",") ?? ["Воскресенье"],
            isRegular: trackerCoreData.isRegular,
            createDate: trackerCoreData.createDate ?? Date()
        )
        return tracker
    }
    
    func header(_ indexPath: IndexPath) -> String {
        let trackerCoreData = fetchedResultController.object(at: indexPath)
        guard let trackerHeader = trackerCoreData.category?.categoryName else {return "Нет такой категории"}
        return trackerHeader
    }
    
    func addRecord(categoryName: String, tracker: Tracker) {
        saveTrackerCategory(categoryName: categoryName, tracker: tracker)
    }
    
    private func saveContext(){
        do{
            try context.save()
        } catch {
            let error = NSError()
            print("Ошибка сохранения \(error.localizedDescription)")
        }
    }
    
    func loadData() -> [TrackerCategory] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let trackerCoreData = try? context.fetch(request)
        var trackerCategories:[TrackerCategory] = []
        guard let trackerCoreData = trackerCoreData else { return [] }
        print(trackerCoreData.count)
        trackerCoreData.forEach({ tracker in
            let categoryName = tracker.category?.categoryName ?? "Пусто"
            print(categoryName)
            let tracker = Tracker(
                trackerId: tracker.trackerId ?? UUID(),
                name: tracker.name ?? "",
                emoji: tracker.emoji ?? "🤬",
                color: UIColor.getUIColor(from: tracker.color ?? "#FFFFFF"),
                schedule: tracker.schedule?.components(separatedBy: ",") ?? ["Воскресенье"],
                isRegular: tracker.isRegular,
                createDate: tracker.createDate ?? Date())
            print(tracker)
            
            if trackerCategories.contains(where: { trackerCategory in
                trackerCategory.categoryName == categoryName
            }) {
                var newTrackerArray:[Tracker] = []
                trackerCategories.forEach ({
                    if $0.categoryName == categoryName {
                        newTrackerArray = $0.trackersOfCategory
                        newTrackerArray.append(tracker)
                    }
                })
                trackerCategories.removeAll { trackerCategory in
                    trackerCategory.categoryName == categoryName
                }
                trackerCategories.append(TrackerCategory(categoryName: categoryName, trackersOfCategory: newTrackerArray))
                
            } else {
                let trackerCategory = TrackerCategory(
                    categoryName: categoryName,
                    trackersOfCategory: [tracker])
                trackerCategories.append(trackerCategory)
            }
        })
        return trackerCategories
    }
    
//    func loadVisibleTrackers(weekday: String, searchedText: String) -> [TrackerCategory] {
//        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
//        if searchedText == "" {
//            request.predicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday)
//        } else {
//            request.predicate = NSPredicate(format: "%K CONTAINS[n] %@ AND %K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday, #keyPath(TrackerCoreData.name.lowercased), searchedText)
//        }
//        let trackerCoreData = try? context.fetch(request)
//        var trackerCategories:[TrackerCategory] = []
//        guard let trackerCoreData = trackerCoreData else { return [] }
//        trackerCoreData.forEach({ tracker in
//            let categoryName = tracker.category?.categoryName ?? "Пусто"
//            print(categoryName)
//            let tracker = Tracker(
//                trackerId: tracker.trackerId ?? UUID(),
//                name: tracker.name ?? "",
//                emoji: tracker.emoji ?? "🤬",
//                color: UIColor.getUIColor(from: tracker.color ?? "#FFFFFF"),
//                schedule: tracker.schedule?.components(separatedBy: ",") ?? ["Воскресенье"],
//                isRegular: tracker.isRegular)
//            if trackerCategories.contains(where: { trackerCategory in
//                trackerCategory.categoryName == categoryName
//            }) {
//                var newTrackerArray:[Tracker] = []
//                trackerCategories.forEach ({
//                    if $0.categoryName == categoryName {
//                        newTrackerArray = $0.trackersOfCategory
//                        newTrackerArray.append(tracker)
//                    }
//                })
//                trackerCategories.removeAll { trackerCategory in
//                    trackerCategory.categoryName == categoryName
//                }
//                trackerCategories.append(TrackerCategory(categoryName: categoryName, trackersOfCategory: newTrackerArray))
//
//            } else {
//                let trackerCategory = TrackerCategory(
//                    categoryName: categoryName,
//                    trackersOfCategory: [tracker])
//                trackerCategories.append(trackerCategory)
//            }
//        })
//        return trackerCategories
//    }
    
    func loadVisibleTrackers(currentDate: Date, searchedText: String) -> [TrackerCategory] {
        let weekday = DateFormatter.weekday(date: currentDate)
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        if searchedText == "" {
            request.predicate = NSPredicate(format: "%K CONTAINS[n] %@ AND !(%K != true AND %K > %ld )", #keyPath(TrackerCoreData.schedule), weekday, #keyPath(TrackerCoreData.isRegular), #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
        } else {
            request.predicate = NSPredicate(format: "%K CONTAINS[n] %@ AND %K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday, #keyPath(TrackerCoreData.name.lowercased), searchedText)
        }
        let trackerCoreData = try? context.fetch(request)
        var trackerCategories:[TrackerCategory] = []
        guard let trackerCoreData = trackerCoreData else { return [] }
        trackerCoreData.forEach({ tracker in
            let categoryName = tracker.category?.categoryName ?? "Пусто"
            print(categoryName)
            let tracker = Tracker(
                trackerId: tracker.trackerId ?? UUID(),
                name: tracker.name ?? "",
                emoji: tracker.emoji ?? "🤬",
                color: UIColor.getUIColor(from: tracker.color ?? "#FFFFFF"),
                schedule: tracker.schedule?.components(separatedBy: ",") ?? ["Воскресенье"],
                isRegular: tracker.isRegular,
                createDate: tracker.createDate ?? Date())
            if trackerCategories.contains(where: { trackerCategory in
                trackerCategory.categoryName == categoryName
            }) {
                var newTrackerArray:[Tracker] = []
                trackerCategories.forEach ({
                    if $0.categoryName == categoryName {
                        newTrackerArray = $0.trackersOfCategory
                        newTrackerArray.append(tracker)
                    }
                })
                trackerCategories.removeAll { trackerCategory in
                    trackerCategory.categoryName == categoryName
                }
                trackerCategories.append(TrackerCategory(categoryName: categoryName, trackersOfCategory: newTrackerArray))
                
            } else {
                let trackerCategory = TrackerCategory(
                    categoryName: categoryName,
                    trackersOfCategory: [tracker])
                trackerCategories.append(trackerCategory)
            }
        })
        return trackerCategories
    }
    
    func isVisibalteTrackersEmpty() -> Bool {
        let currentDate = self.currentDate ?? Date()
        let weekday = DateFormatter.weekday(date: currentDate)
        let searchedText = (self.searchedText).lowercased()
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        if searchedText == "" {
            request.predicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday)
        } else {
            request.predicate = NSPredicate(format: "%K CONTAINS[n] %@ AND %K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday, #keyPath(TrackerCoreData.name.lowercased), searchedText)
        }
        guard let trackerCoreData = try? context.fetch(request) else { return true}
        if trackerCoreData.isEmpty{
            return true
        } else {
            return false
        }
    }
    
    func loadIdNotRegularTrackers() -> [UUID] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let allDays = [
            Weekdays.Monday.rawValue,
            Weekdays.Tuesday.rawValue,
            Weekdays.Wednesday.rawValue,
            Weekdays.Thursday.rawValue,
            Weekdays.Friday.rawValue,
            Weekdays.Saturday.rawValue,
            Weekdays.Sunday.rawValue
        ]
        let allDaysString = allDays.joined(separator: ",")
        var uuids: [UUID] = []
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.schedule), allDaysString)
        let trackerCoreData = try? context.fetch(request)
        guard let trackerCoreData = trackerCoreData else { return [] }
        trackerCoreData.forEach({ tracker in
            let categoryName = tracker.category?.categoryName ?? "Пусто"
            if categoryName.contains(where: { charakter in
                charakter == "🔥"}) {
                print(categoryName)
                uuids.append(tracker.trackerId ?? UUID())
            }
            })
        return uuids
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexPath()
        oldNumberOfSection = fetchedResultController.sections?.count ?? 0
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let indexPath = insertedIndexes {
//            delegate?.addTracker(indexPath: indexPath, insetedSections: insertedSections)
            let indexPathAndSection = IndexPathAndSection(indexPath: indexPath, section: insertedSections)
            delegate?.updateTrackers(with: indexPathAndSection)
        }
        insertedIndexes = nil
        insertedSections = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes = indexPath
                if oldNumberOfSection < (fetchedResultController.sections?.count ?? 0) {
                    oldNumberOfSection = (fetchedResultController.sections?.count ?? 0)
                    insertedSections = indexPath.section
                }
            }

        default:
            break
        }
    }
}
