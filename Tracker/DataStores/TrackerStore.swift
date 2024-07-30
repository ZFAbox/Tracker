//
//  TrackerStore.swift
//  Tracker
//
//  Created by Fedor on 22.07.2024.
//

import Foundation
import CoreData
import UIKit

final class TrackerStore: NSObject{
    
    var context: NSManagedObjectContext
    var delegate: TrackerViewController
    
    init(context: NSManagedObjectContext, delegate: TrackerViewController) {
        self.context = context
        self.delegate = delegate
    }
    
    convenience init(delegate: TrackerViewController) {
        self.init(context: (DataStore().persistentContainer.viewContext), delegate: delegate)
    }
    
    private lazy var fetchResultController: NSFetchedResultsController<TrackerCoreData> = {
    
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptors]
        let fetchResultedController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchResultedController.delegate = self
        try? fetchResultedController.performFetch()
        return fetchResultedController
    }()
    
    func saveTracker(_ tracker: Tracker) {
        let trackerData = TrackerCoreData(context: context)
        trackerData.trackerId = tracker.trackerId
        trackerData.name = tracker.name
        trackerData.emoji = tracker.emoji
        trackerData.color = UIColor.getHexColor(from: tracker.color)
        trackerData.schedule = tracker.schedule.joined(separator: ",")
        saveTracker()
    }
    
    private func saveTracker(){
        do{
            try context.save()
        } catch {
            print("Ошибка сохранения")
        }
    }
    
    
    var numberOfSections: Int {
        fetchResultController.sections?.count ?? 0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        fetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker {
        let trackerCoreData = fetchResultController.object(at: indexPath)
        let tracker = Tracker(
            trackerId: trackerCoreData.trackerId ?? UUID(),
            name: trackerCoreData.name ?? "",
            emoji: trackerCoreData.emoji ?? "🤬",
            color: UIColor.getUIColor(from: trackerCoreData.color ?? "#FFFFFF"),
            schedule: trackerCoreData.schedule?.split(separator: ",") as? [String] ?? ["Воскресенье"])
        return tracker
    }
    
    func addRecord( _ tracker: Tracker) {
        try? saveTracker(tracker)
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
}
