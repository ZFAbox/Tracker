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
    private var oldNumberOfPinSection: Int = 0
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
    
    
    private lazy var fetchedResultControllerPinCategories: NSFetchedResultsController<TrackerCoreData> = {
        let currentDate = self.currentDate ?? Date()
        let searchedText = (self.searchedText).lowercased()
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = getPinPredicate(searchedText: searchedText, currentDate: currentDate, isFileterSelected: false, selectedFilter: "")
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
    
    
    private lazy var fetchedResultController: NSFetchedResultsController<TrackerCoreData> = {
        let currentDate = self.currentDate ?? Date()
        let searchedText = (self.searchedText).lowercased()
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = getPredicate(searchedText: searchedText, currentDate: currentDate, isFileterSelected: false, selectedFilter: "")
        fetchRequest.predicate = predicate
        
        //        let sortDescriptor = NSSortDescriptor(key: #keyPath(TrackerCoreData.category.categoryName), ascending: true) { (string1, string2) -> ComparisonResult in
        //            guard let s1 = string1 as? String, let s2 = string2 as? String else {
        //                return ComparisonResult.orderedSame
        //            }
        //            if s1 == "Закрепленные" {
        //                return ComparisonResult.orderedDescending
        //            } else if s2 == "Закрепленные" {
        //                return ComparisonResult.orderedDescending
        //            } else {
        //                return ComparisonResult.orderedDescending
        //            }
        //        }
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
        fetchedResultController.fetchRequest.predicate = getPredicate(searchedText: "", currentDate: DateFormatter.removeTime(date: Date()), isFileterSelected: false, selectedFilter: "")
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
    
    
    func updateRecord(categoryName: String, tracker: Tracker, indexPath: IndexPath, isPined: Bool) {
        if isPined {
            let trackerData = fetchedResultControllerPinCategories.object(at: indexPath)
            trackerData.trackerId = tracker.trackerId
            trackerData.name = tracker.name
            trackerData.emoji = tracker.emoji
            trackerData.color = UIColor.getHexColor(from: tracker.color)
            trackerData.schedule = tracker.schedule.joined(separator: ",")
            
            let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
            request.predicate = NSPredicate(format: "%K == '\(categoryName)'", #keyPath(TrackerCategoryCoreData.categoryName))
            if let category = try? context.fetch(request).first {
                trackerData.category = category
                print("Существующая категория category.categoryName: \(category.categoryName) = categoryName: \(categoryName)")
            } else {
                let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
                trackerCategoryCoreData.categoryName = categoryName
                trackerData.category = trackerCategoryCoreData
                print("Добавление новой категории trackerCategoryCoreData.categoryName: \( trackerCategoryCoreData.categoryName) = categoryName: \(categoryName)")
            }
        } else {
            let trackerData = fetchedResultController.object(at: indexPath)
            trackerData.trackerId = tracker.trackerId
            trackerData.name = tracker.name
            trackerData.emoji = tracker.emoji
            trackerData.color = UIColor.getHexColor(from: tracker.color)
            trackerData.schedule = tracker.schedule.joined(separator: ",")
            
            let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
            request.predicate = NSPredicate(format: "%K == '\(categoryName)'", #keyPath(TrackerCategoryCoreData.categoryName))
            if let category = try? context.fetch(request).first {
                trackerData.category = category
                print("Существующая категория category.categoryName: \(category.categoryName) = categoryName: \(categoryName)")
            } else {
                let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
                trackerCategoryCoreData.categoryName = categoryName
                trackerData.category = trackerCategoryCoreData
                print("Добавление новой категории trackerCategoryCoreData.categoryName: \( trackerCategoryCoreData.categoryName) = categoryName: \(categoryName)")
            }
        }
        saveContext()
        performFetch()
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
    
    func updateTrackerList(currentDate: Date, searchedText: String, isFilterSelected: Bool, selectedFilter: String) {
        let predicate = getPredicate(searchedText: searchedText, currentDate: currentDate, isFileterSelected: isFilterSelected, selectedFilter: selectedFilter)
        let pinPredicate = getPinPredicate(searchedText: searchedText, currentDate: currentDate, isFileterSelected: isFilterSelected, selectedFilter: selectedFilter)
        fetchedResultController.fetchRequest.predicate = predicate
        fetchedResultControllerPinCategories.fetchRequest.predicate = pinPredicate
        performFetch()
    }
    
    func getPinPredicate(searchedText: String, currentDate: Date, isFileterSelected: Bool, selectedFilter: String) -> NSPredicate {
        let weekday = DateFormatter.weekday(date: currentDate)
        if searchedText == "" {
            let pinCategory = NSPredicate(format: "%K == 'Закрепленные'", #keyPath(TrackerCoreData.category.categoryName))
            
            let  textAndDatePredicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday)
            
            let notRegular = NSPredicate(format: "%K == false", #keyPath(TrackerCoreData.isRegular))
            let isCompletedBeforeCurrentDate = NSPredicate(format: "Any %K < %@",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let neverCompleted = NSPredicate(format: "Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let notVisibleBeforeCreate = NSPredicate(format: "%K <= %@",  #keyPath(TrackerCoreData.createDate), currentDate as NSDate)
            let notRegularAndCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, isCompletedBeforeCurrentDate])
            let removeCompletednotRegular = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.not, subpredicates: [notRegularAndCompleted])
            let notCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [neverCompleted, removeCompletednotRegular])
            
            let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [textAndDatePredicate, notVisibleBeforeCreate, notCompleted, pinCategory])
            
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
    
    func getPredicate1(searchedText: String, currentDate: Date, isFileterSelected: Bool, selectedFilter: String) -> NSPredicate {
        let weekday = DateFormatter.weekday(date: currentDate)
        if searchedText.isEmpty {
            let notPinCategory = NSPredicate(format: "%K != 'Закрепленные'", #keyPath(TrackerCoreData.category.categoryName))
            
            let  textAndDatePredicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday)
            
            let notRegular = NSPredicate(format: "%K == false", #keyPath(TrackerCoreData.isRegular))
            let isCompletedBeforeCurrentDate = NSPredicate(format: "Any %K < %@",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let neverCompleted = NSPredicate(format: "Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let notVisibleBeforeCreate = NSPredicate(format: "%K <= %@",  #keyPath(TrackerCoreData.createDate), currentDate as NSDate)
            let notRegularAndCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, isCompletedBeforeCurrentDate])
            let removeCompletednotRegular = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.not, subpredicates: [notRegularAndCompleted])
            let notCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [neverCompleted, removeCompletednotRegular])
            
            let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [textAndDatePredicate, notVisibleBeforeCreate, notCompleted, notPinCategory])
            
            return predicate
            
        } else {
            let notPinCategory = NSPredicate(format: "%K != 'Закрепленные'", #keyPath(TrackerCoreData.category.categoryName))
            
            let  textAndDatePredicate = NSPredicate(format: "%K CONTAINS[n] %@ AND %K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday, #keyPath(TrackerCoreData.name.lowercased), searchedText)
            
            let notRegular = NSPredicate(format: "%K == false", #keyPath(TrackerCoreData.isRegular))
            let isCompletedBeforeCurrentDate = NSPredicate(format: "Any %K < %@",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let neverCompleted = NSPredicate(format: "Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let notVisibleBeforeCreate = NSPredicate(format: "%K <= %@",  #keyPath(TrackerCoreData.createDate), currentDate as NSDate)
            let notRegularAndCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, isCompletedBeforeCurrentDate])
            let removeCompletednotRegular = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.not, subpredicates: [notRegularAndCompleted])
            let notCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [neverCompleted, removeCompletednotRegular])
            
            let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [textAndDatePredicate, notVisibleBeforeCreate, notCompleted, notPinCategory])
            
            return predicate
        }
    }
    
    
    func getPredicate (searchedText: String, currentDate: Date, isFileterSelected: Bool, selectedFilter: String) -> NSPredicate {
        
        let allTrackers = NSLocalizedString("allTrackers", comment: "")
        let trackerForToday = NSLocalizedString("trackerForToday", comment: "")
        let completedTrackers = NSLocalizedString("completedTrackers", comment: "")
        let notCompletedTracker = NSLocalizedString("notCompletedTracker", comment: "")
        let weekday = DateFormatter.weekday(date: currentDate)
        
        var predicate = NSPredicate(format: "%K != 'Закрепленные'", #keyPath(TrackerCoreData.category.categoryName))
    
        let datePredicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday)
        
        let textPredicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCoreData.name.lowercased), searchedText)
        
        if isFileterSelected && (selectedFilter == allTrackers) {
            predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [ predicate, datePredicate])
            
        } else if isFileterSelected && (selectedFilter == trackerForToday) {
            predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [ predicate, datePredicate])
            
        } else if isFileterSelected && (selectedFilter == completedTrackers) {
            let completed = NSPredicate(format: "Any %K == %@",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [ predicate, datePredicate, completed])
            
        } else if isFileterSelected && (selectedFilter == notCompletedTracker) {
            let notCompleted = NSPredicate(format: "Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate, datePredicate, notCompleted])
            
        } else {

            let notRegular = NSPredicate(format: "%K == false", #keyPath(TrackerCoreData.isRegular))
            let isCompletedBeforeCurrentDate = NSPredicate(format: "Any %K < %@",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let neverCompleted = NSPredicate(format: "Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let notVisibleBeforeCreate = NSPredicate(format: "%K <= %@",  #keyPath(TrackerCoreData.createDate), currentDate as NSDate)
            let notRegularAndCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, isCompletedBeforeCurrentDate])
            let removeCompletednotRegular = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.not, subpredicates: [notRegularAndCompleted])
            let notCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [neverCompleted, removeCompletednotRegular])
            
            predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [ notVisibleBeforeCreate, notCompleted, predicate, datePredicate])
        }
        
        if !searchedText.isEmpty {
            predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate, textPredicate])
        }
        return predicate
    }
    
    
    
    func getAllTrackersPredicate(searchedText: String, currentDate: Date) -> NSPredicate {
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
    
    var numberOfPinSections: Int {
        fetchedResultControllerPinCategories.sections?.count ?? 0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int{
        fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfItemsInSectionPinCategories(_ section: Int) -> Int{
        fetchedResultControllerPinCategories.sections?[section].numberOfObjects ?? 0
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
    
    func objectPinCategoris(_ indexPath: IndexPath) -> Tracker? {
        let trackerCoreData = fetchedResultControllerPinCategories.object(at: indexPath)
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
        trackerCoreData.oldCategory = trackerCoreData.category?.categoryName
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
        performFetch()
    }
    
    func unPinObject(indexPath: IndexPath) {
        let trackerCoreData = fetchedResultControllerPinCategories.object(at: indexPath)
        guard let categoryName = trackerCoreData.oldCategory else { return }
        trackerCoreData.oldCategory = nil
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.categoryName), categoryName)
        request.predicate = predicate
        if let trackerCategoryData = try? context.fetch(request).first {
            trackerCoreData.category = trackerCategoryData
        } else {
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.categoryName = categoryName
            trackerCategoryCoreData.addToTrackersOfCategory(trackerCoreData)
        }
        saveContext()
        performFetch()
    }
    
    func performFetch(){
        try? fetchedResultControllerPinCategories.performFetch()
        try? fetchedResultController.performFetch()
    }
    
    func removeObject(indexPath: IndexPath) {
        performFetch()
        let trackerCoredData = fetchedResultController.object(at: indexPath)
        context.delete(trackerCoredData)
        saveContext()
    }
    
    func removePinObject(indexPath: IndexPath) {
        try? fetchedResultController.performFetch()
        let trackerCoredData = fetchedResultControllerPinCategories.object(at: indexPath)
        context.delete(trackerCoredData)
        saveContext()
    }
    
    func header(_ indexPath: IndexPath) -> String {
        let trackerCoreData = fetchedResultController.object(at: indexPath)
        guard let trackerHeader = trackerCoreData.category?.categoryName else {return "Нет такой категории"}
        return trackerHeader
    }
    
    func headerPinCategories(_ indexPath: IndexPath) -> String {
        let trackerCoreData = fetchedResultControllerPinCategories.object(at: indexPath)
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
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = getAllTrackersPredicate(searchedText: searchedText, currentDate: currentDate)
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
        oldNumberOfPinSection = fetchedResultControllerPinCategories.sections?.count ?? 0
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
        case .move:
            if oldNumberOfPinSection == 0 {
            }
        default:
            break
        }
    }
}
