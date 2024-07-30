//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Fedor on 22.07.2024.
//

import Foundation
import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    
    var context: NSManagedObjectContext
    var delegate: TrackerViewController
    private var categoryAndIdList:[String : ObjectIdentifier] = [:]
    
    init(context: NSManagedObjectContext, delegate: TrackerViewController) {
        self.context = context
        self.delegate = delegate
    }
    
    convenience init(delegate: TrackerViewController) {
        self.init(context: (DataStore().persistentContainer.viewContext), delegate: delegate)
    }
    
    private lazy var fetchedResultController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let sortDescriptor = NSSortDescriptor(key: "categoryName", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCategoryCoreData.categoryName),
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
        fetchedResultController.object(at: IndexPath(index: section)).trackersOfCategory?.count ?? 0
    }
    
    func object(_ indexPath: IndexPath) -> TrackerCategory {
        let trackerCategoryDataCore = fetchedResultController.object(at: indexPath)
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
    
    func loadData1() -> [TrackerCategory] {
        var trackerCategories:[TrackerCategory] = []
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        guard let trackerCategoriesData = try? context.fetch(request) else { return []}
        trackerCategoriesData.forEach({ trackerCategoryData in
            guard let categoryNameData = trackerCategoryData.categoryName, let trackersData = trackerCategoryData.trackersOfCategory else {
                print("Нет данных")
                return }
            print(trackersData.count)
            let trackersOfCategory = trackersData.map({$0}) as? [TrackerCoreData]
            var trackers: [Tracker] = []
            if let trackersOfCategory = trackersOfCategory {
                for trackerCoreData in trackersOfCategory {
                    print(trackerCoreData.schedule?.split(separator: ",") ?? ["Воскресенье"])
                    let tracker = Tracker(
                        trackerId: trackerCoreData.trackerId ?? UUID(),
                        name: trackerCoreData.name ?? "",
                        emoji: trackerCoreData.emoji ?? "🤬",
                        color: UIColor.getUIColor(from: trackerCoreData.color ?? "#FFFFFF"),
                        schedule: trackerCoreData.schedule?.components(separatedBy: ",") ?? ["Воскресенье"])
                    trackers.append(tracker)
                }
            }
            let trackerCategory = TrackerCategory(
                categoryName: categoryNameData,
                trackersOfCategory: trackers)
            trackerCategories.append(trackerCategory)
        })
        return trackerCategories
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
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
}
