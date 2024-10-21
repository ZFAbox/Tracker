//
//  TrackerStore.swift
//  Tracker
//
//  Created by Fedor on 22.07.2024.
//

import Foundation
import CoreData
import UIKit

protocol TrackerCategoryStoreProtocol {
    func updateCategoryList(with insertedIndexes: IndexPath?, and deletedIndexes: IndexPath?)
}

final class TrackerCategoryStore: NSObject{
    
    private var context: NSManagedObjectContext
    private var delegate: TrackerCategoryStoreProtocol?
    
    private var insertedIndexes: IndexPath?
    private var deletedIndexes: IndexPath?
    
    init(context: NSManagedObjectContext, delegate: TrackerCategoryStoreProtocol) {
        self.context = context
        self.delegate = delegate
    }

    convenience init(delegate: TrackerCategoryStoreProtocol) {
        self.init(context: DataStore.shared.viewContext, delegate: delegate)
    }
    
    private lazy var fetchResultController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "categoryName", ascending: false)
        let predicate = NSPredicate(format: "%K != 'Закрепленные'", #keyPath(TrackerCategoryCoreData.categoryName))
        fetchRequest.predicate = predicate
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
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let predicate = NSPredicate(format: "%K == '\(category)'", #keyPath(TrackerCategoryCoreData.categoryName))
        request.predicate = predicate
        if let categoryData = try? context.fetch(request).first {
            return
        } else {
            let categoryCoreData = TrackerCategoryCoreData(context: context)
            categoryCoreData.categoryName = category
            saveContext()
        }
    }
    
    private func saveContext(){
        do{
            try context.save()
        } catch {
            print("Ошибка сохранения контекста")
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
        return categoryName
    }
    
    func addRecord( _ category: String) {
        saveCategory(category)
    }
    
    func removeCategory(at indexPath: IndexPath) {
        let categoryCoreData = fetchResultController.object(at: indexPath)
        context.delete(categoryCoreData)
        saveContext()
    }
    
    func editCategory(at indexPath: IndexPath, with categoryName: String) {
        let categoryCoreData = fetchResultController.object(at: indexPath)
        categoryCoreData.categoryName = categoryName
        saveContext()
        try? fetchResultController.performFetch()
    }
    
    func getCategoryName(at indexPath: IndexPath) -> String {
        let categoryCoreData = fetchResultController.object(at: indexPath)
        guard let categoryName = categoryCoreData.categoryName else { return "" }
        return categoryName
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
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexPath()
        deletedIndexes = IndexPath()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                self.insertedIndexes = indexPath
            }
        case.delete:
            if let indexPath = indexPath {
                self.deletedIndexes = indexPath
            }
        default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateCategoryList(with: insertedIndexes, and: deletedIndexes)
        self.insertedIndexes = nil
        self.deletedIndexes = nil
    }
}
