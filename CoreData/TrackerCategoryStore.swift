//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Dzhami on 03.07.2023.
//

import Foundation
import CoreData

class TrackerCategoryStore: NSObject, TrackerCategoryStoreProtocol {

    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    
    private let databaseManager = DatabaseManager.shared

    convenience override init() {
        let context = DatabaseManager.shared.context
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    private lazy var fetchResultController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
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
        fetchResultController.fetchedObjects?[section].trackers?.count ?? 0
    }

    func addCategory(category: String) throws {
        guard
            let categories = fetchResultController.fetchedObjects,
            categories.first(where: { $0.title == category }) == nil // проверка существования категории
        else {return}
        
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
        fetchResultController.fetchedObjects?.map { $0.title ?? "" } ?? []
    }

    func fetchCategoryName(index: Int) -> String? {
        fetchResultController.fetchedObjects?[index].title
    }

    func fetchCategory(with name: String) -> TrackerCategoryCoreData? {
        fetchResultController.fetchedObjects?.first {
            $0.title == name
        }
    }
}

// MARK: - Extensions

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
     //   databaseManager.getCategoryName()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
}
