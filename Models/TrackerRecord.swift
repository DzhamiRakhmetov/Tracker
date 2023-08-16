//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Джами on 27.04.2023.
//

import Foundation

struct TrackerRecord: Hashable {
    let id: UUID
    let date: Date
    
    init(id: UUID, date: Date) {
        self.id = id
        self.date = date
    }
}
