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
    
    private var context: NSManagedObjectContext
    private weak var delegate: TrackerTableViewController?
    
    init(context: NSManagedObjectContext, delegate: TrackerTableViewController) {
        self.context = context
        self.delegate = delegate
    }
    
    
    convenience init(delegate: TrackerTableViewController) {
        self.init(context: DataStore.shared.viewContext, delegate: delegate)
    }
    
    private lazy var fetchResultController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "categoryName", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptors]
        let fetchResultedController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchResultedController.delegate = self
        try? fetchResultedController.performFetch()
        return fetchResultedController
    }()
    
    func saveCategory(_ category: String) {
        print("Category: \(category)")
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
//        let request = fetchResultController.fetchRequest
        let predicate = NSPredicate(format: "%K == '\(category)'", #keyPath(TrackerCategoryCoreData.categoryName))
        request.predicate = predicate
        if let categoryData = try? context.fetch(request).first {
            print(categoryData.categoryName)
            return
        } else {
            let categoryCoreData = TrackerCategoryCoreData(context: context)
            categoryCoreData.categoryName = category
            saveContext()
        }
        return
    }
    
    private func saveContext(){
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
    
    func object(at indexPath: IndexPath) -> String {
        let categoryCoreData = fetchResultController.object(at: indexPath)
        guard let categoryName = categoryCoreData.categoryName else { return ""}
        print("Объект категории: \(categoryName)")
        return categoryName
    }
    
    func addRecord( _ category: String) {
        saveCategory(category)
    }
    
    func isEmpty() -> Bool {
        let fetchRequest = fetchResultController.fetchRequest
        guard let categoryCoreData = try? context.fetch(fetchRequest) else { return true }
        return categoryCoreData.isEmpty ? true : false
    }
    
    func loadCategories() -> [String] {
        let request = fetchResultController.fetchRequest
        guard let categorysData = try? context.fetch(request) else { return [] }
        var categories:[String] = []
        for category in categorysData {
            categories.append(category.categoryName ?? "")
        }
        return categories
    }
    
    func count() -> Int {
        let request = fetchResultController.fetchRequest
        guard let categorysData = try? context.fetch(request) else { return 0 }
        var categories:[String] = []
        for category in categorysData {
            categories.append(category.categoryName ?? "")
        }
        return categories.count
    }
    
//    func count() -> Int {
//        let fetchRequest = fetchResultController.fetchRequest
//        fetchRequest.resultType = .countResultType
//        let categories = try! context.execute(fetchRequest) as! NSAsynchronousFetchResult<NSFetchRequestResult>
//        guard let count = categories.finalResult?.first else { return 0}
//        return count as! Int
//    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateCategoryTableList()
    }
}
