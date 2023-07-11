//
//  TrackerStoreError.swift
//  Tracker
//
//  Created by Dzhami on 10.07.2023.
//

import Foundation
// MARK: - Errors

enum TrackerStoreError: Error {
    case invalidTrackerID
    case invalidTrackerName
    case invalidTrackerColor
    case invalidTrackerEmoji
    case invalidTrackerScheduleInt
    case hexDeserializationError
}
