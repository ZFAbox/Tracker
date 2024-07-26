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
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience override init() {
        self.init(context: (DataStore().persistentContainer.viewContext))
    }
    
    func saveTrackerCategory(categoryName: String, tracker: Tracker) {
        let trackerRecordData = TrackerCategoryCoreData(context: context)
        let trackerData = TrackerCoreData(context: context)
        trackerData.trackerId = tracker.trackerId
        trackerData.name = tracker.name
        trackerData.emoji = tracker.emoji
        trackerData.color = UIColor.getHexColor(from: tracker.color)
        trackerData.schedule = tracker.schedule.joined(separator: ",")
        trackerRecordData.categoryName = categoryName
        trackerRecordData.addToTrackersOfCategory(trackerData)
        saveTrackerCategory()
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
    
    private func saveTrackerCategory(){
        do{
            try context.save()
        } catch {
            print("Ошибка сохранения")
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
}
