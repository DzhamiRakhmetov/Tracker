
import Foundation
import CoreData

// MARK: - Protocol

protocol TrackerCategoryStoreProtocol {
    func addCategory(category: String) throws
    func deleteCategory(at indexPath: IndexPath) throws
    func changeCategoryName(at indexPath: IndexPath, to newName: String)
    //    func addCategory(category: TrackerCategory) throws
    //    func deleteCategory(category: TrackerCategory) throws
    //    func changeCategoryName(category: TrackerCategory, to newName: String)
    func getCategoriesNames() -> [String]
    func fetchNewCategory(with name: String) -> TrackerCategoryCoreData?
    func fetchCategoryName(index: Int) -> String?
    
}

// MARK: - TrackerCategoryStore

class TrackerCategoryStore: NSObject, TrackerCategoryStoreProtocol {
    
    private let context: NSManagedObjectContext
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
    
    private var numberOfCategories: Int {
        fetchResultController.fetchedObjects?.count ?? 0
    }
    
    private func numberOfRowsInSection(section: Int) -> Int {
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
    
    func changeCategoryName(at indexPath: IndexPath, to newName: String) {
        let categoryCoreData = fetchResultController.object(at: indexPath)
        categoryCoreData.title = newName
        try? context.save()
    }
    
    //    func addCategory(category: TrackerCategory) throws {
    //        guard
    //            let categories = fetchResultController.fetchedObjects,
    //            categories.first(where: { $0.title == category.title }) == nil // проверка существования категории
    //        else {return}
    //
    //        let cat = TrackerCategoryCoreData(context: context)
    //        cat.title = category.title
    //        try context.save()
    //    }
    //
    //    func deleteCategory(category: TrackerCategory) throws {
    //        guard
    //            let categories = fetchResultController.fetchedObjects,
    //            let selectedCategory = categories.first(where: { $0.title == category.title })  else {return}
    //
    //        context.delete(selectedCategory)
    //        try context.save()
    //    }
    //
    //    func changeCategoryName(category: TrackerCategory, to newName: String) {
    //        let categories = fetchResultController.fetchedObjects
    //        let selectedCategory = categories?.first (where: { $0.title == category.title })
    //        selectedCategory?.title = newName
    //        try? context.save()
    //    }
    
    
    
    func getCategoriesNames() -> [String] {
        try? fetchResultController.performFetch()
        return  fetchResultController.fetchedObjects?.map { $0.title ?? "" } ?? []
    }
    
    func fetchCategoryName(index: Int) -> String? {
        fetchResultController.fetchedObjects?[index].title
    }
    
    func categoryStringForTracker(at indexPath: IndexPath) -> String? {
        let trackerCoreData = fetchResultController.object(at: indexPath)
        return trackerCoreData.title
    }
    
    func fetchNewCategory(with name: String) -> TrackerCategoryCoreData? {
        fetchResultController.fetchedObjects?.first {
            $0.title == name
        }
    }
}

// MARK: - Extensions

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
}

