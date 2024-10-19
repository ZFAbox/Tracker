//
//  DataStore.swift
//  Tracker
//
//  Created by Fedor on 22.07.2024.
//

import Foundation
import CoreData

final class DataStore{
    
    static var shared = DataStore().persistentContainer
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainers = NSPersistentContainer(name: "TrackerCoreData")
        persistentContainers.loadPersistentStores { storeDescription, error in
            if let nserror = error as? NSError {
                fatalError("Ошибка инициализации контейнера CoreData")
            }
        }
        return persistentContainers
    }()

    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка сохранения")
            }
        }
    }
    
}
