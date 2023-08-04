
import UIKit
import CoreData

final class DatabaseManager {
    
    private let modelName = "CoreDataModel"
    private var categoryName: [String]?
    static let shared = DatabaseManager()
    
    var completedTrackers: [TrackerRecord]? = []
    var trackerStore: TrackerStoreProtocol?
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
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


