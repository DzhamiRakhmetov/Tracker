//
//  TrackerStore.swift
//  Tracker
//
//  Created by Dzhami on 03.07.2023.
//

import Foundation
import CoreData
import UIKit

//extension NSFetchRequestResult {
//    static var identifier: String { return String(describing: Self.self)}
//}

// MARK: - TrackerStore Class

class TrackerStore: NSObject {
    private var context: NSManagedObjectContext { return databaseManager.context}
    private let databaseManager = DatabaseManager.shared
    
    lazy var fetchResultController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.category?.title, ascending: true)]
        
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.title),
            cacheName: nil)
        
        fetchResultController.delegate = self
        try? fetchResultController.performFetch()
        
        return fetchResultController
    }()
    
    // add tracker
    func addTracker(tracker: Tracker, in category : String ) throws {
        guard let category = TrackerCategoryStore().fetchNewCategoryName(name: category) else { return }
        
        let trackerDB = TrackerCoreData(context: context)
        
        trackerDB.id = tracker.id
        trackerDB.name = tracker.name
        trackerDB.color = UIColorMarshalling.serialize(color: tracker.color)
        trackerDB.emoji = tracker.emoji
        trackerDB.schedule = tracker.schedule
        trackerDB.category = category
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteTracker(at indexPath: IndexPath) throws {
        let trackerCoreData = fetchResultController.object(at: indexPath)
        context.delete(trackerCoreData)
        try context.save()
    }
    
    private func makeTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id else {
            throw TrackerStoreError.invalidTrackerID
        }
        guard let name = trackerCoreData.name else {
            throw TrackerStoreError.invalidTrackerName
        }
        guard let colorHex = trackerCoreData.color else {
            throw TrackerStoreError.invalidTrackerColor
        }
        guard let color = UIColorMarshalling.deserialize(hexString: colorHex) else {
            throw TrackerStoreError.hexDeserializationError
        }
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.invalidTrackerEmoji
        }
        guard let schedule = trackerCoreData.schedule else {
            throw TrackerStoreError.invalidTrackerScheduleInt
        }
        return Tracker(id: id,
                       name: name,
                       color: color,
                       emoji: emoji,
                       schedule: schedule)
    }
    
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
}



