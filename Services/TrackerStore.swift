//
//  TrackerStore.swift
//  Tracker
//
//  Created by Джами on 25.05.2023.
//

import Foundation
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func didUpdateTracker()
}

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
        
        
    }()
    
    init(context: NSManagedObjectContext, delegate: TrackerStoreDelegate) {
        self.context = context
        self.delegate = delegate
    }
}
