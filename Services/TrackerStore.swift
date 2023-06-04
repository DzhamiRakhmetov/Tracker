//
//  TrackerStore.swift
//  Tracker
//
//  Created by Джами on 25.05.2023.
//

import UIKit
import CoreData

// MARK: - Errors

enum TrackerStoreError: Error {
    case invalidTrackerID
    case invalidTrackerName
    case invalidTrackerColor
    case invalidTrackerEmoji
    case invalidTrackerScheduleString
    case hexDeserializationError
}

// MARK: - Protocol

protocol TrackerStoreProtocol {
    var numberOfSections: Int { get }
    func numberOfItemsInSection(_ section: Int) -> Int
    func name(of section: Int) -> String?
    func object(at indexPath: IndexPath) -> Tracker?
    func saveTracker(tracker: Tracker) throws
    func deleteTracker(at indexPath: IndexPath) throws
    func trackersFor(_ currentDate: String, searchRequest: String?)
    func records(for trackerIndexPath: IndexPath) -> Set<TrackerRecordCoreData>
}

protocol TrackerStoreDelegate: AnyObject {
    func didUpdateTracker(_ insertedSections: IndexSet, _ deletedSections: IndexSet, _ updatedIndexPaths: [IndexPath], _ insertedIndexPaths: [IndexPath], _ deletedIndexPaths: [IndexPath])
}

// MARK: - Class TrackerStore

final class TrackerStore: NSObject {
    
    private let context: NSManagedObjectContext
    weak var delegate: TrackerStoreDelegate?
    private lazy var insertedIndexPaths: [IndexPath] = []
    private lazy var deletedIndexPaths: [IndexPath] = []
    private lazy var updatedIndexPaths: [IndexPath] = []
    private lazy var insertedSections = IndexSet()
    private lazy var deletedSections = IndexSet()
    
    
    private lazy var fetchedResultController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[n] %@", #keyPath (TrackerCoreData.schedule))
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.title),
            cacheName: nil)
        
        controller.delegate = self
        try? controller.performFetch()
        
        return controller
    }()
    
    init(context: NSManagedObjectContext, delegate: TrackerStoreDelegate) {
        self.context = context
        self.delegate = delegate
    }
    
    convenience init(delegate: TrackerStoreDelegate) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Error: appDelegate not found")
        }
        self.init(context: appDelegate.persistentContainer.viewContext, delegate: delegate)
    }
    
    private func clearIndexes() {
        insertedIndexPaths = []
        deletedIndexPaths = []
        updatedIndexPaths = []
        insertedSections = IndexSet()
        deletedSections = IndexSet()
    }
   
    private func makeTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.trackerID else {
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
            throw TrackerStoreError.invalidTrackerScheduleString
        }
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule as! [WeekDay])
    }
    
}

// MARK: - Extensions NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTracker(insertedSections, deletedSections, updatedIndexPaths, insertedIndexPaths, deletedIndexPaths)
        clearIndexes()
    }
    
    // Вызывается, когда изменяется информация о секции результата запроса
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert :
            insertedSections.insert(sectionIndex)
        case .delete :
            deletedSections.insert(sectionIndex)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert :
            if let indexPath = newIndexPath {
                insertedIndexPaths.append(indexPath)
            }
        case .delete :
            if let indexPath = indexPath {
                deletedIndexPaths.append(indexPath)
            }
        case .update :
            if let indexPath = indexPath {
                updatedIndexPaths.append(indexPath)
            }
        default: break
        }
    }
}

// MARK: - Extensions TrackerStoreProtocol

extension TrackerStore: TrackerStoreProtocol {
    
    var numberOfSections: Int {
        fetchedResultController.sections?.count ?? 0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func name(of section: Int) -> String? {
        fetchedResultController.sections?[section].name
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        let trackerCoreData = fetchedResultController.object(at: indexPath)
        return try? makeTracker(from: trackerCoreData)
    }
    
    
    func deleteTracker(at indexPath: IndexPath) throws {
        let trackerCoreData = fetchedResultController.object(at: indexPath)
        context.delete(trackerCoreData)
       try context.save()
    }
    
    func saveTracker(tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerID = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = UIColorMarshalling.serialize(color: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule.compactMap {$0.rawValue} as NSObject
        try context.save()
    }
    
    // фильтрция для поиска
    func trackersFor(_ currentDate: String, searchRequest: String?) {

    }

    func records(for trackerIndexPath: IndexPath) -> Set<TrackerRecordCoreData> {

    }
}

