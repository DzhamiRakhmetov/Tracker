//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Dzhami on 03.07.2023.
//

import Foundation
import CoreData

// MARK: - TrackerCategoryStoreProtocol

protocol TrackerCategoryStoreProtocol {
    func addCategory(category: String) throws
    func fetchNewCategoryName(name: String) -> TrackerCategoryCoreData? 
}


// MARK: - TrackerCategoryStore Class
class TrackerCategoryStore: NSObject, TrackerCategoryStoreProtocol {
    
    private let context: NSManagedObjectContext
    
    convenience override init() {
        let context = DatabaseManager.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private lazy var fetchResultController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchResultController.delegate = self
        try? fetchResultController.performFetch()
        
        return fetchResultController
    }()
    
    var numberOfCategories: Int {
        fetchResultController.fetchedObjects?.count ?? 0
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        guard let trackers = fetchResultController.fetchedObjects?[section].trackers else {return 0}
        print(trackers)
        return trackers.count
    }
    
  
    func addCategory(category: String) throws {
        guard let categories = fetchResultController.fetchedObjects else {return}
        
        
        // проверка существования категории
        for cat in categories {
            if cat.title == category {
                return
            }
        }
        let cat = TrackerCategoryCoreData(context: context)
        cat.title = category
        
        try context.save()
    }
    
    func deleteCategory(at indexPath: IndexPath) throws {
        let category = fetchResultController.object(at: indexPath)
        context.delete(category)
        try context.save()
    }
    
    func getCategoriesNames() -> [String] {
           guard let allCategoriesNames =  fetchResultController.fetchedObjects else { return [] }
           
           return allCategoriesNames.map { $0.title ?? "" }
       }
    
    func fetchCategoryName(index: Int) -> String? {
        guard let category  = fetchResultController.fetchedObjects?[index] else {return nil}
        return category.title
    }
    
    func fetchNewCategoryName(name: String) -> TrackerCategoryCoreData? {
        var cat: TrackerCategoryCoreData?
        
        if let categories = fetchResultController.fetchedObjects {
            categories.forEach { category in
                if category.title == name {
                    cat = category
                }
            }
        }
        return cat
    }
    
}

// MARK: - Extensions

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
}
