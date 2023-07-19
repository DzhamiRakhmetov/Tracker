//
//  TrackerStore.swift
//  Tracker
//
//  Created by Dzhami on 03.07.2023.
//

import CoreData
import UIKit



// MARK: - TrackerStore Class

class TrackerStore: NSObject {
    private var context: NSManagedObjectContext { databaseManager.context}
    private let databaseManager = DatabaseManager.shared // !!!!!
    
    lazy var fetchResultController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData") //!!!!!
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.category?.title, ascending: false)]
        
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
    func addTracker(tracker: Tracker, in category: String) throws {
        guard
            let category = TrackerCategoryStore(context: context)
                .fetchCategory(with: category)
        else { return }
        // do not create new object of TrackerCategoryStore !!!!!
        
        let trackerDB = TrackerCoreData(context: context)
        
        trackerDB.id = tracker.id
        trackerDB.name = tracker.name
        trackerDB.color = UIColorMarshalling.serialize(color: tracker.color)
        trackerDB.emoji = tracker.emoji
        trackerDB.schedule = tracker.schedule ?? [] //.map { String($0) }.joined(separator: ",")
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
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchTrackers() -> [TrackerCategory] {
        guard let sections = fetchResultController.sections else { return [] }

        var currentCategory: [TrackerCategory] = []

        for section in sections {
            guard let object = section.objects as? [TrackerCoreData] else { return [] }
            var category = TrackerCategory(title: section.name, trackers: [] )

            for tracker in object {
                category.trackers.append(Tracker(id: tracker.id ?? UUID(),
                                                     name: tracker.name ?? "",
                                                     color: UIColorMarshalling.deserialize(hexString: tracker.color ?? "")!,
                                                     emoji: tracker.emoji ?? "",
                                                     schedule: tracker.schedule))
            }
            currentCategory.append(category)
        }

        return currentCategory
    }
    
    // add func to get all trackers or specific tracker
    
    func getTrackerAt(indexPath: IndexPath) -> Tracker? {
           let trackerCoreData = fetchResultController.object(at: indexPath)
           do {
               let tracker = try makeTracker(from: trackerCoreData)
               return tracker
           } catch {
               return nil
           }
       }
    
    func makeTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
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
        guard let schedule = trackerCoreData.schedule  else {
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
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.fetchTrackers()
        
    }
}



