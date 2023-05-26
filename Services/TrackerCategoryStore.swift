//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Джами on 25.05.2023.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateCategories()
}

final class TrackerCategoryStore: NSObject {
    
    private let context: NSManagedObjectContext
    weak var delegate: TrackerCategoryStoreDelegate?
    
//    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
//        let fetchedRequest = TrackerCategoryCoreData.fetchRequest()
//        fetchedRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        let controller = NSFetchedResultsController(
//            fetchRequest: fetchedRequest,
//            managedObjectContext: context,
//            sectionNameKeyPath: nil,
//            cacheName: nil)
//
//      //  controller.delegate = self
//        try? controller.performFetch()
//
//        return controller
//    }()
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
//    override convenience init() {
//        
//    }
}