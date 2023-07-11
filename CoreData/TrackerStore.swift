//
//  TrackerStore.swift
//  Tracker
//
//  Created by Dzhami on 03.07.2023.
//

import Foundation
import CoreData
import UIKit

extension NSFetchRequestResult {
    static var identifier: String { return String(describing: Self.self)}
}

// MARK: - TrackerStore Class

class TrackerStore: NSObject {
    private var context: NSManagedObjectContext { return databaseManager.context}
    private let databaseManager = DatabaseManager.shared
    
    lazy var fetchResultController: [TrackerCoreData] = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)]
        
        guard let array = try? context.fetch(fetchRequest) else {
            return []
        }
//        let fetchResultController = NSFetchedResultsController(
//            fetchRequest: fetchRequest,
//            managedObjectContext: context,
//            sectionNameKeyPath: #keyPath(TrackerCoreData.name),
//            cacheName: nil)
//
//        fetchResultController.delegate = self
//        try? fetchResultController.performFetch()
        
        return array
    }()
    
    func getTrackers(section name: String) -> [TrackerCoreData] {
        print(name)
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "TrackerCoreData.name", ascending: true)]
        
        guard let array = try? context.fetch(fetchRequest) else {
            return []
        }
        return array
    }
    
//    private func makeTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
//        guard let name = trackerCoreData.name else {
//            throw TrackerStoreError.invalidTrackerName
//        }
//        guard let colorHex = trackerCoreData.color else {
//            throw TrackerStoreError.invalidTrackerColor
//        }
//        guard let color = UIColorMarshalling.deserialize(hexString: colorHex) else {
//            throw TrackerStoreError.hexDeserializationError
//        }
//        guard let emoji = trackerCoreData.emoji else {
//            throw TrackerStoreError.invalidTrackerEmoji
//        }
//        guard let schedule = trackerCoreData.schedule else {
//            throw TrackerStoreError.invalidTrackerScheduleInt
//        }
//        let sheduleInt = schedule.compactMap { WeekDay(rawValue: $0) }
//
//        return Tracker(name: name, color: color, emoji: emoji, schedule: sheduleInt)
//    }
    
    // add tracker to category
    func add(category name: String, _ tracker: Tracker) {
        guard let category = TrackerCategoryStore().fetchNewCategoryName(name: name) else { return }
        
        let trackerBD = TrackerCoreData(context: context)
        
        trackerBD.id = tracker.id
        trackerBD.name = tracker.name
        trackerBD.color = UIColorMarshalling.serialize(color: tracker.color)
        trackerBD.emoji = tracker.emoji
        trackerBD.schedule = tracker.schedule
        trackerBD.category = category
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        fetchResultController.count
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
}


extension TrackerCoreData {
    var schedule: [WeekDay] {
        get {
            guard let data = scheduleData,
                  let value = try? JSONDecoder().decode([WeekDay].self, from: data)
            else {return []}
            return value
        }
        
        set {
            let value = try? JSONEncoder().encode(newValue)
            scheduleData = value
        }
    }
}
