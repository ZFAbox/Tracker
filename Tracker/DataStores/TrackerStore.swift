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
    private var insertedIndexes: IndexPath? = nil
    private var deleteIndexes: IndexPath? = nil
    private var oldNumberOfSection: Int = 0
    private var oldNumberOfPinSection: Int = 0
    private var insertedSections: Int? = nil
    private var deletedSections: Int? = nil
    private var numberOfItems: Int? = nil
    
    init(context: NSManagedObjectContext, delegate: TrackerStoreUpdateDelegateProtocol) {
        self.context = context
        self.delegate = delegate
    }
    
    convenience init(delegate: TrackerStoreUpdateDelegateProtocol) {
        self.init(context: DataStore.shared.viewContext, delegate: delegate)
    }
    
    private lazy var fetchedResultControllerPinCategories: NSFetchedResultsController<TrackerCoreData> = {
        let currentDate = DateFormatter.removeTime(date: Date())
        let searchedText = ""
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = getPinPredicate(searchedText: searchedText, currentDate: currentDate, isFileterSelected: false, selectedFilter: "")
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: #keyPath(TrackerCoreData.category.categoryName), ascending: false)
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
        let currentDate = DateFormatter.removeTime(date: Date())
        let searchedText = ""
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = getPredicate(searchedText: searchedText, currentDate: currentDate, isFileterSelected: false, selectedFilter: "")
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: #keyPath(TrackerCoreData.category.categoryName), ascending: false)
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
        fetchedResultControllerPinCategories.fetchRequest.predicate = getPinPredicate(searchedText: "", currentDate: DateFormatter.removeTime(date: Date()), isFileterSelected: false, selectedFilter: "")
        try? fetchedResultController.performFetch()
        try? fetchedResultControllerPinCategories.performFetch()
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
        } else {
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.categoryName = categoryName
            trackerData.category = trackerCategoryCoreData
        }
        saveContext()
        performFetch()
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
            } else {
                let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
                trackerCategoryCoreData.categoryName = categoryName
                trackerData.category = trackerCategoryCoreData
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
            } else {
                let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
                trackerCategoryCoreData.categoryName = categoryName
                trackerData.category = trackerCategoryCoreData
            }
        }
        saveContext()
        performFetch()
    }
    
    
    func updateTrackerList(currentDate: Date, searchedText: String, isFilterSelected: Bool, selectedFilter: String) {
        let predicate = getPredicate(searchedText: searchedText, currentDate: currentDate, isFileterSelected: isFilterSelected, selectedFilter: selectedFilter)
        let pinPredicate = getPinPredicate(searchedText: searchedText, currentDate: currentDate, isFileterSelected: isFilterSelected, selectedFilter: selectedFilter)
        fetchedResultController.fetchRequest.predicate = predicate
        fetchedResultControllerPinCategories.fetchRequest.predicate = pinPredicate
        performFetch()
    }
    
    func getPinPredicate(searchedText: String, currentDate: Date, isFileterSelected: Bool, selectedFilter: String) -> NSPredicate {
        let allTrackers = NSLocalizedString("allTrackers", comment: "")
        let trackerForToday = NSLocalizedString("trackerForToday", comment: "")
        let completedTrackers = NSLocalizedString("completedTrackers", comment: "")
        let notCompletedTracker = NSLocalizedString("notCompletedTracker", comment: "")
        let weekday = DateFormatter.weekday(date: currentDate)
        
        var predicate = NSPredicate(format: "%K == 'Закрепленные'", #keyPath(TrackerCoreData.category.categoryName))
    
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
            let notRegular = NSPredicate(format: "%K == false", #keyPath(TrackerCoreData.isRegular))
            let notComppletedBeforeCurrentDate = NSPredicate(format: "Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate))
            
            let notRegularAndNotCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, notComppletedBeforeCurrentDate])
            
            let regular = NSPredicate(format: "%K == true", #keyPath(TrackerCoreData.isRegular))
            let notCompleted = NSPredicate(format: "Any %K != %@ OR Any %K == nil" ,  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate, #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate )
            
            let regularAndNotCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [regular, notCompleted])
            
            let notCompletedTrackers = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [notRegularAndNotCompleted, regularAndNotCompleted])
            predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate, datePredicate, notCompletedTrackers])
        } else {

            let notRegular = NSPredicate(format: "%K == false", #keyPath(TrackerCoreData.isRegular))
            let isCompletedBeforeCurrentDate = NSPredicate(format: "Any %K < %@",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let isCompletedAfterCurrentDate = NSPredicate(format: "Any %K > %@",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let neverCompleted = NSPredicate(format: "Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let notRegularAndCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, isCompletedBeforeCurrentDate])
            let notRegularAndCompletedAfter = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, isCompletedAfterCurrentDate])
            let removeCompletednotRegular = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.not, subpredicates: [notRegularAndCompleted])
            let removeCompletednotRegularAfter = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.not, subpredicates: [notRegularAndCompletedAfter])
            let notregularAndCompletedExcluded = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [removeCompletednotRegular, removeCompletednotRegularAfter])
            let notCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [neverCompleted, notregularAndCompletedExcluded])
            
            predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [ notCompleted, predicate, datePredicate])
        }
        
        if !searchedText.isEmpty {
            predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate, textPredicate])
        }
        return predicate
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
            let notRegular = NSPredicate(format: "%K == false", #keyPath(TrackerCoreData.isRegular))
            let notComppletedBeforeCurrentDate = NSPredicate(format: "Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate))
            
            let notRegularAndNotCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, notComppletedBeforeCurrentDate])
            
            let regular = NSPredicate(format: "%K == true", #keyPath(TrackerCoreData.isRegular))
            let notCompleted = NSPredicate(format: "Any %K != %@ OR Any %K == nil" ,  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate, #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate )
            
            let regularAndNotCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [regular, notCompleted])
            
            let notCompletedTrackers = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [notRegularAndNotCompleted, regularAndNotCompleted])
            predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate, datePredicate, notCompletedTrackers])
        } else {
            
            let notRegular = NSPredicate(format: "%K == false", #keyPath(TrackerCoreData.isRegular))
            let isCompletedBeforeCurrentDate = NSPredicate(format: "Any %K < %@",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let isCompletedAfterCurrentDate = NSPredicate(format: "Any %K > %@",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let neverCompleted = NSPredicate(format: "Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), currentDate as NSDate)
            let notRegularAndCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, isCompletedBeforeCurrentDate])
            let notRegularAndCompletedAfter = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, isCompletedAfterCurrentDate])
            let removeCompletednotRegular = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.not, subpredicates: [notRegularAndCompleted])
            let removeCompletednotRegularAfter = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.not, subpredicates: [notRegularAndCompletedAfter])
            let notregularAndCompletedExcluded = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [removeCompletednotRegular, removeCompletednotRegularAfter])
            let notCompleted = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [neverCompleted, notregularAndCompletedExcluded])
            
            predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [ notCompleted, predicate, datePredicate])
        }
        
        if !searchedText.isEmpty {
            predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate, textPredicate])
        }
        return predicate
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
    
    func isVisibalteTrackersEmpty(searchedText: String, currentDate: Date) -> Bool {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = getPredicate(searchedText: searchedText, currentDate: currentDate, isFileterSelected: false, selectedFilter: "")
        request.predicate = predicate
        guard let trackerCoreData = try? context.fetch(request) else { return true}
        if trackerCoreData.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func isVisibaltePinTrackersEmpty(searchedText: String, currentDate: Date) -> Bool {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = getPinPredicate(searchedText: searchedText, currentDate: currentDate, isFileterSelected: false, selectedFilter: "")
        request.predicate = predicate
        guard let trackerCoreData = try? context.fetch(request) else { return true}
        if trackerCoreData.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func removeAllTrackers() {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        guard let trackerCoreData = try? context.fetch(request) else { return }
        for tracker in trackerCoreData {
            context.delete(tracker)
            saveContext()
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
    
    func getActiveTrackersPerDay(date: Date) -> Int {
        let weekday = DateFormatter.weekday(date: date)
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let datePredicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekday)
        let trackersCreatedBeforeDate = NSPredicate(format: " %K <= %@" , #keyPath(TrackerCoreData.createDate), date as NSDate)
        let regular = NSPredicate(format: "%K == true" , #keyPath(TrackerCoreData.isRegular))
        let notRegular = NSPredicate(format: "%K == false", #keyPath(TrackerCoreData.isRegular))
        let notComppletedBeforeCurrentDate = NSPredicate(format: "Any %K >= %@ OR Any %K == nil",  #keyPath(TrackerCoreData.trackerRecord.trackerDate), date as NSDate, #keyPath(TrackerCoreData.trackerRecord.trackerDate))
        
        let notRegularCompletedLater = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [notRegular, notComppletedBeforeCurrentDate])
        
        let trackersToSelect = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [regular, notRegularCompletedLater])
        
        let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [trackersCreatedBeforeDate, trackersToSelect, datePredicate])
        request.predicate = predicate
        guard let trackerCoreData = try? context.fetch(request) else { return 0}
        return trackerCoreData.count
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
                let section = indexPath.section
                if row == 0 {
                    if let numberOfSections = controller.sections {
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
