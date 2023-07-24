//
//  Protocols.swift
//  Tracker
//
//  Created by Dzhami on 21.07.2023.
//

import Foundation

protocol TrackerStoreProtocol: AnyObject {
    func createTracker(_ tracker: Tracker, categoryName: String)
  //  func fetchTrackers() -> [TrackerCategory]
}


// MARK: - TrackerCategoryStoreProtocol

protocol TrackerCategoryStoreProtocol: AnyObject {
    func addCategory(category: String) throws
    func fetchCategory(with name: String) -> TrackerCategoryCoreData?
  //  func getCategoriesNames() -> [String]
}

// MARK: - TrackerRecordStoreProtocol

protocol TrackerRecordStoreProtocol: AnyObject {
   // func fetchTrackerRecords() -> [TrackerRecord]
}


