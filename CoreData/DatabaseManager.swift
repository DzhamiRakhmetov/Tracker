//
//  DatabaseManager.swift
//  Tracker
//
//  Created by Dzhami on 03.07.2023.
//

import Foundation
import CoreData

final class DatabaseManager {
    
    private let modelName = "CoreDataModel"
    static let shared = DatabaseManager()
    var completedTrackers: [TrackerRecord]? = []
    var trackerStore: TrackerStoreProtocol?
    var trackerCategoryStore: TrackerCategoryStoreProtocol?
    var trackerRecordStore: TrackerRecordStoreProtocol?
    
    private var categoryName: [String]?
    var visibleCategories: [TrackerCategory]? 
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
  
    
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    func fetchRecordFromStore() {
//        completedTrackers = trackerRecordStore?.fetchTrackerRecords()
//    }
//    
//    func getCategoryName() {
//        categoryName = trackerCategoryStore?.getCategoriesNames()
//    }
//    
//    func fetchVisibleCategoriesFromStore() {
//        visibleCategories = trackerStore?.fetchTrackers()
//    }
    
}
