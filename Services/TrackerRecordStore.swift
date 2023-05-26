//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Джами on 25.05.2023.
//

import UIKit
import CoreData

protocol RecordStoreProtocol {
    func save(_ record: TrackerRecord) throws
    func delete(_ record: TrackerRecord) throws
}


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
}
