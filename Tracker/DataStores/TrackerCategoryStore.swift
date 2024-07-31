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
    func addTracker(indexes: IndexSet)
}

final class TrackerCategoryStore: NSObject {
    
    var context: NSManagedObjectContext
    private weak var delegate: TrackerViewController?
    private var currentDate: Date?
    private var searchedText: String
    
    init(context: NSManagedObjectContext, delegate: TrackerViewController, currentDate: Date?, searchedText: String) {
        self.context = context
        self.delegate = delegate
        self.currentDate = currentDate
        self.searchedText = searchedText
    }
    
    convenience init(delegate: TrackerViewController, currentDate: Date?, searchedText: String) {
        self.init(context: DataStore.shared.viewContext, delegate: delegate, currentDate: currentDate, searchedText: searchedText)
    }
    
    private lazy var fetchedResultController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let sortDescriptor = NSSortDescriptor(key: #keyPath(TrackerCoreData.name), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
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
    
    
    var numberOfSections: Int {
        fetchedResultController.sections?.count ?? 0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int{
        fetchedResultController.object(at: IndexPath(item: <#T##Int#>, section: <#T##Int#>))
        fetchedResultController.object(at: IndexPath(index: section)).trackersOfCategory?.count ?? 0
    }
    
    func object(_ indexPath: IndexPath) -> TrackerCategory {
        let trackerataCore = fetchedResultController.object(at: indexPath)
        let trackersOfCategory = trackerCategoryDataCore.trackersOfCategory?.map({$0}) as? [TrackerCoreData]
        var trackers: [Tracker] = []
        if let trackersOfCategory = trackersOfCategory {
            for trackerCoreData in trackersOfCategory {
                let tracker = Tracker(
                    trackerId: trackerCoreData.trackerId ?? UUID(),
                    name: trackerCoreData.name ?? "",
                    emoji: trackerCoreData.emoji ?? "🤬",
                    color: UIColor.getUIColor(from: trackerCoreData.color ?? "#FFFFFF"),
                    schedule: trackerCoreData.schedule?.split(separator: ",") as? [String] ?? ["Воскресенье"])
                trackers.append(tracker)
            }
        }
        let trackerCategory = TrackerCategory(
            categoryName: trackerCategoryDataCore.categoryName ?? "None",
            trackersOfCategory: trackers)
        return trackerCategory
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
    
    //    func loadData1() -> [TrackerCategory] {
    //        var trackerCategories:[TrackerCategory] = []
    //        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
    //        guard let trackerCategoriesData = try? context.fetch(request) else { return []}
    //        trackerCategoriesData.forEach({ trackerCategoryData in
    //            guard let categoryNameData = trackerCategoryData.categoryName, let trackersData = trackerCategoryData.trackersOfCategory else {
    //                print("Нет данных")
    //                return }
    //            print(trackersData.count)
    //            let trackersOfCategory = trackersData.map({$0}) as? [TrackerCoreData]
    //            var trackers: [Tracker] = []
    //            if let trackersOfCategory = trackersOfCategory {
    //                for trackerCoreData in trackersOfCategory {
    //                    print(trackerCoreData.schedule?.split(separator: ",") ?? ["Воскресенье"])
    //                    let tracker = Tracker(
    //                        trackerId: trackerCoreData.trackerId ?? UUID(),
    //                        name: trackerCoreData.name ?? "",
    //                        emoji: trackerCoreData.emoji ?? "🤬",
    //                        color: UIColor.getUIColor(from: trackerCoreData.color ?? "#FFFFFF"),
    //                        schedule: trackerCoreData.schedule?.components(separatedBy: ",") ?? ["Воскресенье"])
    //                    trackers.append(tracker)
    //                }
    //            }
    //            let trackerCategory = TrackerCategory(
    //                categoryName: categoryNameData,
    //                trackersOfCategory: trackers)
    //            trackerCategories.append(trackerCategory)
    //        })
    //        return trackerCategories
    //    }
    
    
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
                schedule: tracker.schedule?.components(separatedBy: ",") ?? ["Воскресенье"])
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
    
    func loadDataVisibleTrackers(weekDay: String, searchedText: String) -> [TrackerCategory] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        if searchedText == "" {
            request.predicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekDay)
        } else {
            request.predicate = NSPredicate(format: "%K CONTAINS[n] %@ AND %K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), weekDay, #keyPath(TrackerCoreData.name), searchedText)
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
                schedule: tracker.schedule?.components(separatedBy: ",") ?? ["Воскресенье"])
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
    
    func loadIdNotRegularTrackers(searchedText: String) -> [UUID] {
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
        if searchedText == "" {
            request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.schedule), allDaysString)
        } else {
            request.predicate = NSPredicate(format: "%K == %@ AND %K CONTAINS[n] %@", #keyPath(TrackerCoreData.schedule), allDaysString, #keyPath(TrackerCoreData.name), searchedText)
        }
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
    
}
