//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Dzhami on 03.07.2023.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    
    private let context: NSManagedObjectContext
    
    
    convenience override init() {
        let context = DatabaseManager.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
//    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
//        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
//
//        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.id, ascending: true)]
//
//        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
//                                                                  managedObjectContext: context,
//                                                                  sectionNameKeyPath: nil,
//                                                                  cacheName: nil)
//        fetchedResultsController.delegate = self
//        try? fetchedResultsController.performFetch()
//        return fetchedResultsController
//    }()
//
//    func isRecordExist(tracker: TrackerRecord) -> Bool {
//        guard let objects = fetchedResultsController.fetchedObjects else { return false }
//
//        var result = false
//
//        objects.forEach { object in
//            let isSameDay = Calendar.current.isDate(tracker.date, inSameDayAs: object.date ?? Date())
//            if object.id == tracker.id && isSameDay {
//                result = true
//            }
//        }
//        return result
//    }
//
//    func addTrackerRecord(tracker: TrackerRecord) {
//        if !isRecordExist(tracker: tracker) {
//            let record = TrackerRecordCoreData(context: context)
//            record.id = tracker.id
//            record.date = tracker.date
//
//            do {
//                try context.save()
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    func fetchTrackerRecords() -> [TrackerRecord] {
//        guard let records = fetchedResultsController.fetchedObjects else { return [] }
//
//        var currentRecord: [TrackerRecord] = []
//
//        for record in records {
//            currentRecord.append(TrackerRecord(id: record.id ?? UUID(),
//                                               date: record.date ?? Date()))
//        }
//        return currentRecord
//    }
}
    


extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    
}
