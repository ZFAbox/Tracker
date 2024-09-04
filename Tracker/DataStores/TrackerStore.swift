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
    let insertIndexPath: IndexPath?
    let section: Int?
    let deleteIndexPath: IndexPath?
    let deletedSection: Int?
    
}

final class TrackerStore: NSObject {
    
    private var context: NSManagedObjectContext
    private var delegate: TrackerStoreUpdateDelegateProtocol?
    private var currentDate: Date?
    private var searchedText: String
    private var insertedIndexes: IndexPath? = nil
    private var deleteIndexes: IndexPath? = nil
    private var oldNumberOfSection: Int = 0
    private var insertedSections: Int? = nil
    private var deletedSections: Int? = nil
    private var numberOfItems: Int? = nil
    
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
        let searchedText = (self.searchedText).lowercased()
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = getPredicate(searchedText: searchedText, currentDate: currentDate)
        fetchRequest.predicate = predicate
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
    
    func perform(){
        fetchedResultController.fetchRequest.predicate = getPredicate(searchedText: "", currentDate: DateFormatter.removeTime(date: Date()))
        try? fetchedResultController.performFetch()
    }
    
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
            print("Существующая категория category.categoryName: \(category.categoryName) = categoryName: \(categoryName)")
//            category.addToTrackersOfCategory(trackerData)
        } else {
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.categoryName = categoryName
//            trackerCategoryCoreData.addToTrackersOfCategory(trackerData)
            trackerData.category = trackerCategoryCoreData
            print("Добавление новой категории trackerCategoryCoreData.categoryName: \( trackerCategoryCoreData.categoryName) = categoryName: \(categoryName)")
        }
        saveContext()
        try? fetchedResultController.performFetch()
    }
    
//    func saveTrackerCategory(categoryName: String, tracker: Tracker) {
//        let trackerData = TrackerCoreData(context: context)
//        trackerData.trackerId = tracker.trackerId
//        trackerData.name = tracker.name
//        trackerData.emoji = tracker.emoji
//        trackerData.color = UIColor.getHexColor(from: tracker.color)
//        trackerData.schedule = tracker.schedule.joined(separator: ",")
//        trackerData.isRegular = tracker.isRegular
//        trackerData.createDate = tracker.createDate
//        print(categoryName)
//        let request = fetchedResultController.fetchRequest
////        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
//        request.predicate = NSPredicate(format: "%K == '\(categoryName)'", #keyPath(TrackerCoreData.category.categoryName))
//        try? fetchedResultController.performFetch()
//        if let trackersData = fetchedResultController.fetchedObjects?.first {
//            let category = trackersData.category
//            category?.addToTrackersOfCategory(trackersData)
//            print(category!.categoryName!)
//        } else {
//            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
//            trackerCategoryCoreData.categoryName = categoryName
//            trackerCategoryCoreData.addToTrackersOfCategory(trackerData)
//        }
//        saveContext()
//        try? fetchedResultController.performFetch()
//    }
    
    func updateDateAndText(currentDate: Date, searchedText: String ) {
        let predicate = getPredicate(searchedText: searchedText, currentDate: currentDate)
        fetchedResultController.fetchRequest.predicate = predicate
        try? fetchedResultController.performFetch()
    }
    
    func getPredicate(searchedText: String, currentDate: Date) -> NSPredicate {
        let weekday = DateFormatter.weekday(date: currentDate)
        if searchedText == "" {
            let  textAndDatePredicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday)
            
            let notRegular = NSPredicate(format: "%K == false", #keyPath(TrackerCoreData.isRegular))
            let isCompletedBeforeCurrentDate = NSPredicate(format: "Any %K < %@",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let neverCompleted = NSPredicate(format: "Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let notVisibleBeforeCreate = NSPredicate(format: "%K <= %@",  #keyPath(TrackerCoreData.createDate), currentDate as NSDate)
            let notRegularAndCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, isCompletedBeforeCurrentDate])
            let removeCompletednotRegular = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.not, subpredicates: [notRegularAndCompleted])
            let notCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [neverCompleted, removeCompletednotRegular])
            
            let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [textAndDatePredicate, notVisibleBeforeCreate, notCompleted])
            
            return predicate
            
        } else {
            
            let  textAndDatePredicate = NSPredicate(format: "%K CONTAINS[n] %@ AND %K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday, #keyPath(TrackerCoreData.name.lowercased), searchedText)
            
            let notRegular = NSPredicate(format: "%K == false", #keyPath(TrackerCoreData.isRegular))
            let isCompletedBeforeCurrentDate = NSPredicate(format: "Any %K < %@",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let neverCompleted = NSPredicate(format: "Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let notVisibleBeforeCreate = NSPredicate(format: "%K <= %@",  #keyPath(TrackerCoreData.createDate), currentDate as NSDate)
            let notRegularAndCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, isCompletedBeforeCurrentDate])
            let removeCompletednotRegular = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.not, subpredicates: [notRegularAndCompleted])
            let notCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [neverCompleted, removeCompletednotRegular])
            
            let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [textAndDatePredicate, notVisibleBeforeCreate, notCompleted])
            
            return predicate
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
    
    func pinObject(indexPath: IndexPath) {
        let trackerCoreData = fetchedResultController.object(at: indexPath)
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.categoryName), "Закрепленные")
        request.predicate = predicate
        if let trackerCategoryData = try? context.fetch(request).first {
            trackerCoreData.category = trackerCategoryData
        } else {
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.categoryName = "Закрепленные"
            trackerCategoryCoreData.addToTrackersOfCategory(trackerCoreData)
        }
        saveContext()
        try? fetchedResultController.performFetch()
    }
    
    func removeObject(indexPath: IndexPath) {
        try? fetchedResultController.performFetch()
        let trackerCoredData = fetchedResultController.object(at: indexPath)
        context.delete(trackerCoredData)
        saveContext()
        //        try? fetchedResultController.performFetch()
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
    
    func isVisibalteTrackersEmpty(searchedText: String, currentDate: Date) -> Bool {
        //        if let fetchedObjects = fetchedResultController.fetchedObjects {
        //            try? fetchedResultController.performFetch()
        //            return fetchedObjects.isEmpty
        //        }
        //        try? fetchedResultController.performFetch()
        //        return true
        
        //        let currentDate = self.currentDate ?? Date()
        //        let searchedText = (self.searchedText).lowercased()
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = getPredicate(searchedText: searchedText, currentDate: currentDate)
        request.predicate = predicate
        guard let trackerCoreData = try? context.fetch(request) else { return true}
        if trackerCoreData.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func isTrackersExist() -> Bool {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        guard let trackerData = try? context.fetch(request) else { return false }
        if trackerData.isEmpty {
            return false
        } else {
            return true
        }
    }
}


extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexPath()
        deleteIndexes = IndexPath()
        oldNumberOfSection = fetchedResultController.sections?.count ?? 0
        //        numberOfItems = fetchedResultController.sections
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //        if let indexPath = insertedIndexes {
        //            delegate?.addTracker(indexPath: indexPath, insetedSections: insertedSections)
        let indexPathAndSection = IndexPathAndSection(insertIndexPath: insertedIndexes, section: insertedSections, deleteIndexPath: deleteIndexes, deletedSection: deletedSections)
        delegate?.updateTrackers(with: indexPathAndSection)
        //        }
        insertedIndexes = nil
        insertedSections = nil
        deleteIndexes = nil
        deletedSections = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes = indexPath
                guard let newNumberOfSection = fetchedResultController.sections  else { return }
                if oldNumberOfSection < newNumberOfSection.count {
                    insertedSections = indexPath.section
                } else {
                    insertedSections = nil
                }
            }
            deleteIndexes = nil
            deletedSections = nil
        case .delete:
            if let indexPath = indexPath {
                deleteIndexes = indexPath
                let row = indexPath.row
                print("row: \(row)")
                let section = indexPath.section
                print("section: \(section)")
                if row == 0 {
                    if let numberOfSections = controller.sections {
                        print("numberOfSections: \(numberOfSections.count)")
                        //                        if numberOfSections.isEmpty {
                        //                            deletedSections = indexPath.section
                        //                        } else {
                        //                            print(numberOfSections[indexPath.section].numberOfObjects)
                        //                            if numberOfSections[indexPath.section].numberOfObjects == 0 {
                        //                                deletedSections = indexPath.section
                        //                            } else {
                        //                                deletedSections = nil
                        //                            }
                        //                        }
                        if numberOfSections.count < oldNumberOfSection {
                            deletedSections = indexPath.section
                        } else {
                            deletedSections = nil
                        }
                    } else {
                        deletedSections = indexPath.section
                    }
                }
            } else {
                deletedSections = nil
            }
            insertedIndexes = nil
            insertedSections = nil
        default:
            break
        }
    }
}
