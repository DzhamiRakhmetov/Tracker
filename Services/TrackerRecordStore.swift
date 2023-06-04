//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Джами on 25.05.2023.
//

import UIKit
import CoreData

// MARK: - Errors

enum TrackerRecordError: Error {
    case itemNotFound
    case savingError
    case invalidTrackerID
    case invalidDate
}

// MARK: - Protocol

protocol TrackerRecordStoreProtocol {
    func save(_ record: TrackerRecord) throws
    func delete(_ record: TrackerRecord) throws
}

// MARK: - Class TrackerRecordStore

final class TrackerRecordStore: NSObject {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Error: appDelegate not found")
        }
        self.init(context: appDelegate.persistentContainer.viewContext)
    }
    
    private func makeRecord(from recordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let trackerID = recordCoreData.tracker?.trackerID else {
            throw TrackerRecordError.invalidTrackerID
        }
        guard let date = recordCoreData.date else {
            throw TrackerRecordError.invalidDate
        }
        return TrackerRecord(id: trackerID, date: date)
    }
}

// MARK: - extension TrackerRecordStore

extension TrackerRecordStore: TrackerRecordStoreProtocol {
    
    func save(_ record: TrackerRecord) throws {
        let requestTracker = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        requestTracker.returnsObjectsAsFaults = false
        requestTracker.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerID), record.id as CVarArg)
        guard let trackerCoreData = try? context.fetch(requestTracker) else {
            throw TrackerRecordError.savingError
        }
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.date = record.date
        trackerRecordCoreData.tracker = trackerCoreData.first
        try context.save()
    }
    
    func delete(_ record: TrackerRecord) throws {
        let requestRecord = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        requestRecord.returnsObjectsAsFaults = false
        requestRecord.predicate = NSPredicate(format: "%K == %@ AND %K == %@ ",
            #keyPath(TrackerRecordCoreData.tracker.trackerID), record.id as CVarArg,
            #keyPath(TrackerRecordCoreData.date), record.date as CVarArg)
        guard let recordCoreData = try? context.fetch(requestRecord).first else {
            throw TrackerRecordError.itemNotFound
        }
        context.delete(recordCoreData)
        try context.save()
    }
}
